import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisa_eat_2/domain/menu/entity/menu_entity.dart';
import 'package:unisa_eat_2/domain/menu/entity/piatto_entity.dart';
import 'package:unisa_eat_2/presentation/menu/bloc/menu_cubit.dart';
import 'package:unisa_eat_2/presentation/menu/bloc/menu_state.dart';
import 'package:unisa_eat_2/common/utils/date_utils.dart';
import 'package:unisa_eat_2/core/services/time_service.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/service_locator.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late DateTime selectedDate;

  // Ordine personalizzato delle categorie
  static const List<String> categoryOrder = [
    'Primi',
    'Secondi',
    'Contorni',
    'Dolce',
    'Bevande',
  ];

  String _getLocalizedCategory(String categoria, AppLocalizations l10n) {
    switch (categoria) {
      case 'Primi':
        return l10n.category_first;
      case 'Secondi':
        return l10n.category_second;
      case 'Contorni':
        return l10n.category_side;
      case 'Dolce':
        return l10n.category_dessert;
      case 'Bevande':
        return l10n.category_drink;
      default:
        return l10n.category_other;
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateUtils.getInitialDate();
    
    Future.microtask(() {
      if (mounted) {
        context.read<MenuCubit>().fetchMenuByDate(DateUtils.formatDateForApi(selectedDate));
      }
    });
  }

  

  bool _isWeekday(DateTime date) {
    return date.weekday >= 1 && date.weekday <= 5;
  }

  

  String _formatDate(DateTime date, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final days = [
      l10n.weekdays_monday,
      l10n.weekdays_tuesday,
      l10n.weekdays_wednesday,
      l10n.weekdays_thursday,
      l10n.weekdays_friday,
      l10n.weekdays_saturday,
      l10n.weekdays_sunday,
    ];
    final months = [
      l10n.months_january,
      l10n.months_february,
      l10n.months_march,
      l10n.months_april,
      l10n.months_may,
      l10n.months_june,
      l10n.months_july,
      l10n.months_august,
      l10n.months_september,
      l10n.months_october,
      l10n.months_november,
      l10n.months_december,
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  Future<void> _showDatePicker() async {
    final menuCubit = context.read<MenuCubit>();
    final prefs = await SharedPreferences.getInstance();
    final debugMode = prefs.getBool('debug_mode') ?? false;

    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: sl<TimeService>().now().add(const Duration(days: 365)),
      selectableDayPredicate: debugMode ? null : (DateTime date) => _isWeekday(date),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          selectedDate = pickedDate;
        });
        menuCubit.fetchMenuByDate(DateUtils.formatDateForApi(pickedDate));
      }
    });
  }

  int _getCategoryPriority(String categoria) {
    final index = categoryOrder.indexOf(categoria);
    return index >= 0 ? index : categoryOrder.length;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
        children: [
          // Date Picker Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: _showDatePicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                 decoration: BoxDecoration(
                   color: Theme.of(context).colorScheme.surface,
                   borderRadius: BorderRadius.circular(12.0),
                   border: Border.all(
                     color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                     width: 1.5,
                   ),
                 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                           AppLocalizations.of(context)!.date,
                           style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                 color: Theme.of(context).colorScheme.primary,
                               ),
                         ),
                        const SizedBox(height: 4.0),
                         Text(
                           _formatDate(selectedDate, context),
                           style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                 fontWeight: FontWeight.w600,
                                 color: Theme.of(context).colorScheme.onSurface,
                               ),
                         ),
                      ],
                    ),
                     Icon(
                       Icons.calendar_today,
                       color: Theme.of(context).colorScheme.primary,
                     ),
                  ],
                ),
              ),
            ),
          ),
           // Menu content
           Expanded(
             child: BlocBuilder<MenuCubit, MenuState>(
               builder: (context, state) {
                 if (state is MenuLoading) {
                   return const Center(
                     child: CircularProgressIndicator(),
                   );
                 } else if (state is MenuLoaded) {
                   return _buildMenu(state.menu, l10n);
                  } else if (state is MenuError) {
                    return _buildError(state.error, l10n);
                  }
                 return const Center(
                   child: CircularProgressIndicator(),
                 );
               },
             ),
           ),
        ],
      );
  }

  Widget _buildMenu(MenuEntity menu, AppLocalizations l10n) {
    if (menu.piatti == null || menu.piatti!.isEmpty) {
      return Center(
        child: Text(
          l10n.no_menu_found,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
        ),
      );
    }

    // Group dishes by category
    final Map<String, List<dynamic>> groupedPiatti = {};
    for (var piatto in menu.piatti!) {
      final categoria = piatto.categoria ?? 'Altro';
      if (!groupedPiatti.containsKey(categoria)) {
        groupedPiatti[categoria] = [];
      }
      groupedPiatti[categoria]!.add(piatto);
    }

    // Sort categories by priority order
    final sortedCategories = groupedPiatti.keys.toList()
      ..sort((a, b) => _getCategoryPriority(a).compareTo(_getCategoryPriority(b)));

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: sortedCategories.length,
      itemBuilder: (context, categoryIndex) {
        final categoria = sortedCategories[categoryIndex];
        final piatti = groupedPiatti[categoria]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Title
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
              child: Text(
                _getLocalizedCategory(categoria, AppLocalizations.of(context)!),
                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
                       fontWeight: FontWeight.w700,
                       color: Theme.of(context).colorScheme.primary,
                     ),
              ),
            ),
            // Dishes in this category
            ...piatti.asMap().entries.map((entry) {
              final piatto = entry.value;
              final isLast = entry.key == piatti.length - 1;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: isLast ? 0 : 12.0,
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and price row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                piatto.nome ?? 'Senza nome',
                                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),

                              ),
                            ),
                            const SizedBox(width: 8.0),
                            if (piatto.costoBase != null)
                               Text(
                                 '€${piatto.costoBase!.toStringAsFixed(2)}',
                                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                       fontWeight: FontWeight.w600,
                                       color: Theme.of(context).colorScheme.primary,
                                     ),
                               ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        // Description
                        if (piatto.descrizione != null)
                           Text(
                             piatto.descrizione!,
                             style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                   color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                 ),
                           ),
                        if (piatto.descrizione != null) const SizedBox(height: 8.0),
                        // Allergens
                        if (piatto.allergeni != null && piatto.allergeni!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                             decoration: BoxDecoration(
                               color: Theme.of(context).colorScheme.primary,
                               borderRadius: BorderRadius.circular(6.0),
                               border: Border.all(color: Theme.of(context).colorScheme.error),
                             ),
                             child: Text(
                               '⚠️ ${piatto.allergeni}',
                               style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                     color: Theme.of(context).colorScheme.onPrimary,
                                   ),
                             ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

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

  Widget _buildError(ApiError error, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.0,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16.0),
           Text(
             _getErrorMessage(error, l10n),
             style: Theme.of(context).textTheme.titleMedium?.copyWith(
                   fontWeight: FontWeight.w600,
                 ),
           ),
          const SizedBox(height: 8.0),
    
          ElevatedButton(
            onPressed: () => context.read<MenuCubit>().fetchMenuByDate(DateUtils.formatDateForApi(selectedDate)),
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}
