import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/order/models/dish_selection_model.dart';
import 'package:unisa_eat_2/domain/menu/entity/piatto_entity.dart';
import 'package:unisa_eat_2/domain/menu/usecases/get_dishes_usecase.dart';
import 'package:unisa_eat_2/domain/menu/usecases/get_menu_by_date_usecase.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/order_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/order_state.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/widget/custom_card.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/wallet_cubit.dart';
import 'package:unisa_eat_2/service_locator.dart';
import 'package:unisa_eat_2/core/services/time_service.dart';

class OrderCreationScreen extends StatefulWidget {
  const OrderCreationScreen({super.key});

  @override
  State<OrderCreationScreen> createState() => _OrderCreationScreenState();
}

class _OrderCreationScreenState extends State<OrderCreationScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();
  final Map<int, int> _quantities = {};
  final Map<int, DateTime?> _pickupTimes = {};
  late TabController _tabController;
  late List<DishSelection> _cartItems;
  bool _debugMode = false;

  String _getErrorMessage(ApiError error, AppLocalizations l10n) {
    switch (error.type) {
      case ErrorType.network:
        return l10n.error_network;
      case ErrorType.server:
        return l10n.error_server;
      case ErrorType.auth:
        return l10n.error_auth;
      case ErrorType.validation:
        return l10n.error_validation;
      case ErrorType.balance:
        return l10n.error_balance;
      case ErrorType.unknown:
        return l10n.error_unknown;
    }
  }

  List<DishSelection> _menuDishes = [];
  List<DishSelection> _exclusiveDishes = [];
  bool _isLoadingDishes = true;
  String? _dishesError;
  DateTime? _selectedPickupTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cartItems = [];
    _loadDishes();
    _loadDebugMode();
    // Set default pickup time to 12:00
    final now = sl<TimeService>().now();
    _selectedPickupTime = DateTime(now.year, now.month, now.day, 12, 0);
  }

  Future<void> _loadDebugMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _debugMode = prefs.getBool('debug_mode') ?? false;
    });
  }

  List<DateTime> _getAvailablePickupTimes() {
    final now = sl<TimeService>().now();
    final today = DateTime(now.year, now.month, now.day);
    List<DateTime> times = [];

    if (_debugMode) {
      // In DEBUG MODE, show all times from 12:00 to 15:00 for testing
      DateTime currentTime = DateTime(today.year, today.month, today.day, 12, 0);
      while (currentTime.hour < 15 || (currentTime.hour == 15 && currentTime.minute == 0)) {
        times.add(currentTime);
        currentTime = currentTime.add(const Duration(minutes: 15));
        if (currentTime.hour > 15) break;
      }
    } else {
      // Calculate start time: now + 15 minutes, rounded up to next 15-minute boundary
      DateTime startTime = now.add(const Duration(minutes: 15));
      int startTotalMin = startTime.hour * 60 + startTime.minute;
      int roundedMin = ((startTotalMin + 14) ~/ 15) * 15;
      int startHour = roundedMin ~/ 60;
      int startMinute = roundedMin % 60;

      DateTime currentTime = DateTime(today.year, today.month, today.day, startHour, startMinute);

      // Ensure start time is not before 12:00
      DateTime minTime = DateTime(today.year, today.month, today.day, 12, 0);
      if (currentTime.isBefore(minTime)) currentTime = minTime;

      // Generate times from start time to 15:00 in 15-minute intervals
      while (currentTime.hour < 15 || (currentTime.hour == 15 && currentTime.minute == 0)) {
        times.add(currentTime);
        currentTime = currentTime.add(const Duration(minutes: 15));
        if (currentTime.hour > 15) break;
      }
    }

    return times;
  }

  void _selectPickupTime() async {
    final availableTimes = _getAvailablePickupTimes();

    // Show time picker dialog
    final selectedTime = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Pickup Time'),
              if (_debugMode)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'DEBUG MODE - All times available',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: availableTimes.length,
              itemBuilder: (context, index) {
                final time = availableTimes[index];
                final isSelected = _selectedPickupTime != null &&
                    time.hour == _selectedPickupTime!.hour &&
                    time.minute == _selectedPickupTime!.minute;

                return ListTile(
                  title: Text(_formatTime(time)),
                  leading: Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  ),
                  onTap: () {
                    Navigator.of(context).pop(time);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        _selectedPickupTime = selectedTime;
      });
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _loadDishes() async {
    setState(() {
      _isLoadingDishes = true;
      _dishesError = null;
    });

    try {
      // Get today's date
      final today = DateFormat('yyyy-MM-dd').format(sl<TimeService>().now());

      // Load all dishes
      final dishesResult = await sl<GetDishesUsecase>().call();
      final menuResult = await sl<GetMenuByDateUsecase>().call(params: today);

      dishesResult.fold(
        (error) => setState(() {
          _dishesError = 'Failed to load dishes: $error';
          _isLoadingDishes = false;
        }),
        (dishesData) {
          // Helper function to safely parse numbers
          double? _parseDouble(dynamic value) {
            if (value is num) return value.toDouble();
            if (value is String) return double.tryParse(value);
            return null;
          }

          final allDishes = (dishesData as List).map((dish) => PiattoEntity(
            piattoId: dish['id'],
            nome: dish['name'],
            descrizione: dish['description'],
            costoBase: _parseDouble(dish['base_cost']),
            categoria: dish['category'],
            allergeni: dish['allergens'],
          )).toList();

          // Get menu dish IDs from today's menu
          final menuDishIds = <int>{};
          menuResult.fold(
            (menuError) {
              // If menu loading fails, continue without menu dishes
              print('Failed to load menu: $menuError');
            },
            (menuData) {
              if (menuData is List && menuData.isNotEmpty) {
                for (final menu in menuData) {
                  if (menu['dishes'] is List) {
                    for (final dish in menu['dishes']) {
                      menuDishIds.add(dish['id'] as int);
                    }
                  }
                }
              }
            },
          );

          // Separate dishes into menu and exclusive
          final menuDishes = <DishSelection>[];
          final exclusiveDishes = <DishSelection>[];

          for (final dish in allDishes) {
            if (dish.piattoId != null && dish.costoBase != null) {
              // Handle price conversion safely
              double? price;
              if (dish.costoBase is num) {
                price = (dish.costoBase as num).toDouble();
              } else if (dish.costoBase is String) {
                price = double.tryParse(dish.costoBase as String);
              }

              if (price != null) {
                final dishSelection = DishSelection(
                  dishId: dish.piattoId!,
                  name: dish.nome ?? '',
                  description: dish.descrizione ?? '',
                  price: price,
                  category: dish.categoria ?? '',
                  allergens: dish.allergeni,
                );

                if (dish.categoria == 'Order Exclusive') {
                  exclusiveDishes.add(dishSelection);
                } else if (menuDishIds.contains(dish.piattoId)) {
                  menuDishes.add(dishSelection);
                }
              }
            }
          }

          setState(() {
            _menuDishes = menuDishes;
            _exclusiveDishes = exclusiveDishes;
            _isLoadingDishes = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _dishesError = 'Unexpected error: $e';
        _isLoadingDishes = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _addToCart(DishSelection dish) {
    setState(() {
      final existingIndex = _cartItems.indexWhere((item) => item.dishId == dish.dishId);
      if (existingIndex >= 0) {
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: _cartItems[existingIndex].quantity + 1,
        );
      } else {
        _cartItems.add(dish.copyWith(quantity: 1));
      }
    });
  }

  void _removeFromCart(int dishId) {
    setState(() {
      final existingIndex = _cartItems.indexWhere((item) => item.dishId == dishId);
      if (existingIndex >= 0) {
        if (_cartItems[existingIndex].quantity > 1) {
          _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
            quantity: _cartItems[existingIndex].quantity - 1,
          );
        } else {
          _cartItems.removeAt(existingIndex);
        }
      }
    });
  }

  double get _totalCost => _cartItems.fold(0.0, (sum, item) => sum + item.subtotal);

  void _createOrder() async {
    // Check debug mode
    final prefs = await SharedPreferences.getInstance();
    final debugMode = prefs.getBool('debug_mode') ?? false;

    if (!debugMode) {
      // Check if today is a weekday (Monday to Friday)
      final now = sl<TimeService>().now();
      if (now.weekday < 1 || now.weekday > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orders can only be placed on weekdays (Monday to Friday)')),
        );
        return;
      }

      // Check if current time is before 14:45
      if ((now.hour == 14 && now.minute > 45) || now.hour > 14) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orders can only be placed before 14:45')),
        );
        return;
      }
    }

    // Check if pickup time is selected
    if (_selectedPickupTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a pickup time')),
      );
      return;
    }

    final request = OrderCreationRequest(
      dishes: _cartItems.where((dish) => dish.quantity > 0).toList(),
      note: _noteController.text.trim(),
      pickupTime: _selectedPickupTime,
      debugMode: _debugMode,
    );

    context.read<OrderCubit>().createOrder(request);
  }

  Widget _buildDishList(List<DishSelection> dishes) {
    if (_isLoadingDishes) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_dishesError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Failed to load dishes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _dishesError!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDishes,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (dishes.isEmpty) {
      return const Center(
        child: Text('No dishes available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dishes.length,
      itemBuilder: (context, index) {
        final dish = dishes[index];
        final cartQuantity = _cartItems
            .where((item) => item.dishId == dish.dishId)
            .fold(0, (sum, item) => sum + item.quantity);

        return CustomCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dish.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '€${dish.price.toStringAsFixed(2)}',
                       style: Theme.of(context).textTheme.titleSmall?.copyWith(
                         fontWeight: FontWeight.bold,
                         color: Theme.of(context).colorScheme.primary,
                       ),
                    ),
                    Row(
                      children: [
                        if (cartQuantity > 0) ...[
                          IconButton(
                            onPressed: () => _removeFromCart(dish.dishId),
                            icon: const Icon(Icons.remove),
                            color: Colors.red,
                          ),
                          Text(
                            cartQuantity.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                        IconButton(
                          onPressed: () => _addToCart(dish),
                          icon: const Icon(Icons.add),
                            color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order created successfully!')),
          );
          context.read<OrderCubit>().getOrders(); // Refresh orders list
          context.read<WalletCubit>().getData(); // Refresh wallet balance
          context.read<UserProfileCubit>().getUser(forceRefresh: true); // Refresh user profile
          Navigator.of(context).pop();
        } else if (state is OrderFailure) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_getErrorMessage(state.error, l10n))),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Order'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Today\'s Menu (${_menuDishes.length})'),
              Tab(text: 'Order Exclusives (${_exclusiveDishes.length})'),
            ],
          ),
        ),
        body: Column(
          children: [
            if (_debugMode)
              Container(
                color: Colors.red,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'DEBUG MODE ENABLED',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDishList(_menuDishes),
                  _buildDishList(_exclusiveDishes),
                ],
              ),
            ),
            if (_cartItems.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                   border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._cartItems.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.quantity}x ${item.name}'),
                          Text('€${item.subtotal.toStringAsFixed(2)}'),
                        ],
                      ),
                    )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '€${_totalCost.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pickup Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _selectPickupTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                           border: Border.all(color: Theme.of(context).colorScheme.outline),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 12),
                            Text(
                              _selectedPickupTime != null
                                  ? _formatTime(_selectedPickupTime!)
                                  : 'Select pickup time',
                               style: TextStyle(
                                 color: _selectedPickupTime != null
                                     ? Theme.of(context).colorScheme.onSurface
                                     : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                               ),
                            ),
                            const Spacer(),
                             Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        hintText: 'Add a note (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<OrderCubit, OrderState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is OrderCreating ? null : _createOrder,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: state is OrderCreating
                              ? const CircularProgressIndicator()
                              : const Text('Place Order'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}