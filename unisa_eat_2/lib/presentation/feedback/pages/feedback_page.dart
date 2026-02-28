import 'package:flutter/material.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/feedback/models/feedback_model.dart';
import 'package:unisa_eat_2/data/feedback/sources/feedback_api_service.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/service_locator.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String _selectedCategory = 'suggestion';
  bool _isLoading = false;
  
  final _feedbackApiService = sl<FeedbackApiService>();

  final List<Map<String, String>> _categories = [
    {'value': 'suggestion', 'key': 'feedback_suggestion'},
    {'value': 'complaint', 'key': 'feedback_complaint'},
    {'value': 'bug', 'key': 'feedback_bug'},
    {'value': 'other', 'key': 'feedback_other'},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final result = await _feedbackApiService.createFeedback(
      _selectedCategory,
      _messageController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.feedback_error),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
      (feedback) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.feedback_sent),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.send_feedback),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.feedback_category,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['value'],
                    child: Text(_getCategoryLabel(category['key']!, l10n)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              Text(
                l10n.feedback_message,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                maxLines: 6,
                maxLength: 1000,
                decoration: InputDecoration(
                  hintText: l10n.feedback_hint,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your feedback';
                  }
                  if (value.trim().length < 10) {
                    return 'Feedback must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        l10n.send_feedback,
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'feedback_suggestion':
        return l10n.feedback_suggestion;
      case 'feedback_complaint':
        return l10n.feedback_complaint;
      case 'feedback_bug':
        return l10n.feedback_bug;
      case 'feedback_other':
        return l10n.feedback_other;
      default:
        return key;
    }
  }
}
