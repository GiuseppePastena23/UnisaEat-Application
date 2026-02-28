import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/faq/models/faq_model.dart';
import 'package:unisa_eat_2/data/faq/sources/faq_api_service.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/service_locator.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  late Future<List<FAQModel>> _faqsFuture;
  final _faqApiService = sl<FAQApiService>();

  @override
  void initState() {
    super.initState();
    _faqsFuture = _loadFAQs();
  }

  Future<List<FAQModel>> _loadFAQs() async {
    final result = await _faqApiService.getFAQs();
    return result.fold(
      (error) => throw Exception(error.toString()),
      (faqs) => faqs,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.faq),
      ),
      body: FutureBuilder<List<FAQModel>>(
        future: _faqsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.error_loading_faq,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _faqsFuture = _loadFAQs();
                      });
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          final faqs = snapshot.data ?? [];
          
          if (faqs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.no_faqs,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          final groupedFAQs = _groupByCategory(faqs);

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedFAQs.length,
            itemBuilder: (context, index) {
              final category = groupedFAQs.keys.elementAt(index);
              final categoryFAQs = groupedFAQs[category]!;

              return ExpansionTile(
                leading: Icon(_getCategoryIcon(category)),
                title: Text(
                  _getCategoryName(category, l10n),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: categoryFAQs.map((faq) => _buildFAQItem(faq, l10n)).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Map<String, List<FAQModel>> _groupByCategory(List<FAQModel> faqs) {
    final Map<String, List<FAQModel>> grouped = {};
    for (final faq in faqs) {
      grouped.putIfAbsent(faq.category, () => []).add(faq);
    }
    return grouped;
  }

  Widget _buildFAQItem(FAQModel faq, AppLocalizations l10n) {
    return ExpansionTile(
      title: Text(
        faq.question,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            faq.answer,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'payments':
        return Icons.payment;
      case 'account':
        return Icons.account_circle;
      case 'orders':
        return Icons.shopping_bag;
      default:
        return Icons.help;
    }
  }

  String _getCategoryName(String category, AppLocalizations l10n) {
    switch (category) {
      case 'payments':
        return l10n.faq_category_payments;
      case 'account':
        return l10n.faq_category_account;
      case 'orders':
        return l10n.faq_category_orders;
      default:
        return l10n.faq_category_general;
    }
  }
}
