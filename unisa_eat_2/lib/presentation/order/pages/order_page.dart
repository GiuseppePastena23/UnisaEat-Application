import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisa_eat_2/domain/order/entities/order_entity.dart';
import 'package:unisa_eat_2/domain/menu/entity/piatto_entity.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/order_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/order_state.dart';
import 'package:unisa_eat_2/presentation/shared/widget/custom_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with WidgetsBindingObserver {
  final Set<int> _expandedOrders = {};
  final Set<int> _dismissedOrderIds = {};
  String sortBy = 'dateDesc';
  String? filterStatus;
  bool _debugMode = false;
  List<OrderEntity> _allOrders = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDebugMode();
    context.read<OrderCubit>().getOrders();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadDebugMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _debugMode = prefs.getBool('debug_mode') ?? false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<OrderCubit>().getOrders();
    }
  }

  void _toggleExpanded(int orderId) {
    setState(() {
      if (_expandedOrders.contains(orderId)) {
        _expandedOrders.remove(orderId);
      } else {
        _expandedOrders.add(orderId);
      }
    });
  }

  void _dismissOrder(int orderId) {
    setState(() {
      _dismissedOrderIds.add(orderId);
    });
  }

  void _showQrDialog(BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order QR Code'),
        content: SizedBox(
          width: 200,
          height: 200,
          child: QrImageView(
            data: orderId.toString(),
            version: QrVersions.auto,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatPickupTime(DateTime pickupTime) {
    final hour = pickupTime.hour.toString().padLeft(2, '0');
    final minute = pickupTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  List<OrderEntity> _filterAndSort(Iterable<OrderEntity> orders) {
    var filtered = orders.toList();

    if (filterStatus != null && filterStatus!.isNotEmpty) {
      filtered = filtered.where((order) => order.status == filterStatus).toList();
    }

    filtered.sort((a, b) {
      switch (sortBy) {
        case 'dateDesc':
          return b.createdAt.compareTo(a.createdAt);
        case 'dateAsc':
          return a.createdAt.compareTo(b.createdAt);
        case 'priceDesc':
          return b.totalCost.compareTo(a.totalCost);
        case 'priceAsc':
          return a.totalCost.compareTo(b.totalCost);
        default:
          return 0;
      }
    });

    return filtered;
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No orders found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sort by:', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'dateDesc', label: Text('Newest')),
              ButtonSegment(value: 'dateAsc', label: Text('Oldest')),
              ButtonSegment(value: 'priceDesc', label: Text('Highest Price')),
              ButtonSegment(value: 'priceAsc', label: Text('Lowest Price')),
            ],
            selected: {sortBy},
            onSelectionChanged: (selected) {
              setState(() {
                sortBy = selected.first;
              });
            },
          ),
          const SizedBox(height: 16),
          Text('Filter by status:', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: filterStatus == null,
                onSelected: (selected) {
                  setState(() {
                    filterStatus = selected ? null : '';
                  });
                },
              ),
              FilterChip(
                label: const Text('Pending'),
                selected: filterStatus == 'pending',
                onSelected: (selected) {
                  setState(() {
                    filterStatus = selected ? 'pending' : null;
                  });
                },
              ),
              FilterChip(
                label: const Text('Confirmed'),
                selected: filterStatus == 'confirmed',
                onSelected: (selected) {
                  setState(() {
                    filterStatus = selected ? 'confirmed' : null;
                  });
                },
              ),
              FilterChip(
                label: const Text('Preparing'),
                selected: filterStatus == 'preparing',
                onSelected: (selected) {
                  setState(() {
                    filterStatus = selected ? 'preparing' : null;
                  });
                },
              ),
              FilterChip(
                label: const Text('Ready'),
                selected: filterStatus == 'ready',
                onSelected: (selected) {
                  setState(() {
                    filterStatus = selected ? 'ready' : null;
                  });
                },
              ),
              FilterChip(
                label: const Text('Completed'),
                selected: filterStatus == 'completed',
                onSelected: (selected) {
                  setState(() {
                    filterStatus = selected ? 'completed' : null;
                  });
                },
              ),
              FilterChip(
                label: const Text('Cancelled'),
                selected: filterStatus == 'cancelled',
                onSelected: (selected) {
                  setState(() {
                    filterStatus = selected ? 'cancelled' : null;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusProgressBar(String status) {
    final statuses = ['pending', 'confirmed', 'preparing', 'ready', 'completed'];
    final currentIndex = statuses.indexOf(status.toLowerCase());
    if (currentIndex == -1) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: 4,
      child: Row(
        children: statuses.asMap().entries.map((entry) {
          final isCompleted = entry.key <= currentIndex;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: isCompleted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderList(List<OrderEntity> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isExpanded = _expandedOrders.contains(order.id);

        final card = CustomCard(
          child: InkWell(
            onTap: () => _toggleExpanded(order.id),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${order.id}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text('Total: €${order.totalCost.toStringAsFixed(2)}'),
                            Text('Date: ${order.createdAt.toLocal().toString().split(' ')[0]}'),
                            Text('Items: ${order.dishes.length}'),
                            if (order.pickupTime != null)
                              Text('Pickup: ${_formatPickupTime(order.pickupTime!)}'),
                            if (order.note != null && order.note!.isNotEmpty)
                              Text('Note: ${order.note}'),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => _showQrDialog(context, order.id),
                        icon: const Icon(Icons.qr_code),
                        tooltip: 'Show QR Code',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(order.status),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  if (isExpanded) ...[
                    const Divider(),
                    ...order.dishes.map((dish) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('${dish.quantity}x ${dish.dish.nome} - €${dish.subtotal.toStringAsFixed(2)}'),
                    )),
                    _buildStatusProgressBar(order.status),
                  ],
                ],
              ),
            ),
          ),
        );

        if (order.status == 'cancelled' || order.status == 'completed') {
          return Dismissible(
            key: Key(order.id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) => _dismissOrder(order.id),
            child: card,
          );
        }

        return card;
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.yellow.shade700;
      case 'ready':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    return status[0].toUpperCase() + status.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        if (state is OrderInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is OrderSuccess) {
          final orders = state.orders;
          _allOrders = List.from(orders);
          final filtered = _filterAndSort(_allOrders.where((o) => !_dismissedOrderIds.contains(o.id)).toList());
          return Scaffold(
            appBar: AppBar(
              title: const Text('Orders'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.push('/order/create');
              },
              child: const Icon(Icons.add),
            ),
            body: filtered.isEmpty
                ? _buildEmptyState()
                : _buildOrderList(filtered),
          );
        } else if (state is OrderLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is OrderFailure) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 50),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load orders',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<OrderCubit>().getOrders(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Handle any other states (should not normally be reached)
          return const Scaffold(
            body: Center(child: Text('Unknown state')),
          );
        }
      },
    );
  }
}