import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/domain/menu/entity/menu_entity.dart';
import 'package:unisa_eat_2/presentation/menu/bloc/menu_cubit.dart';
import 'package:unisa_eat_2/presentation/menu/bloc/menu_state.dart';
import 'package:unisa_eat_2/common/utils/date_utils.dart';

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

  @override
  void initState() {
    super.initState();
    selectedDate = DateUtils.getInitialDate();
    
    Future.microtask(() {
      context.read<MenuCubit>().fetchMenuByDate(DateUtils.formatDateForApi(selectedDate));
    });
  }

  

  bool _isWeekday(DateTime date) {
    return date.weekday >= 1 && date.weekday <= 5;
  }

  

  String _formatDate(DateTime date) {
    final days = ['Lunedì', 'Martedì', 'Mercoledì', 'Giovedì', 'Venerdì', 'Sabato', 'Domenica'];
    final months = [
      'Gennaio',
      'Febbraio',
      'Marzo',
      'Aprile',
      'Maggio',
      'Giugno',
      'Luglio',
      'Agosto',
      'Settembre',
      'Ottobre',
      'Novembre',
      'Dicembre'
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  void _showDatePicker() {
    final menuCubit = context.read<MenuCubit>();

    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (DateTime date) => _isWeekday(date),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        elevation: 0,
      ),
      body: Column(
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
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Colors.teal.shade300,
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
                          'Data',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.teal.shade700,
                              ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          _formatDate(selectedDate),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: Colors.teal.shade700,
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
                  return _buildMenu(state.menu);
                } else if (state is MenuError) {
                  return _buildError(state.message);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(MenuEntity menu) {
    if (menu.piatti == null || menu.piatti!.isEmpty) {
      return Center(
        child: Text(
          'Nessun piatto disponibile',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
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
                categoria,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.teal.shade700,
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
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            if (piatto.costoBase != null)
                              Text(
                                '€${piatto.costoBase!.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.teal.shade600,
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
                                  color: Colors.grey.shade700,
                                ),
                          ),
                        if (piatto.descrizione != null) const SizedBox(height: 8.0),
                        // Allergens
                        if (piatto.allergeni != null && piatto.allergeni!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Text(
                              '⚠️ ${piatto.allergeni}',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.red.shade700,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.0,
            color: Colors.red.shade600,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Errore nel caricamento',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => context.read<MenuCubit>().fetchMenuByDate(DateUtils.formatDateForApi(selectedDate)),
            child: const Text('Riprova'),
          ),
        ],
      ),
    );
  }
}
