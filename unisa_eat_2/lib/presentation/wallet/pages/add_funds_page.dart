import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/add_funds_cubit.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/wallet_cubit.dart';

class AddFundsPage extends StatefulWidget {
  const AddFundsPage({super.key});

  @override
  State<AddFundsPage> createState() => _AddFundsPageState();
}

class _AddFundsPageState extends State<AddFundsPage> {
  final TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    amountController.text = '5.00';
    amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  Future<void> _processPayment(BuildContext context, double amount) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      // Create payment intent on backend
      final cubit = context.read<AddFundsCubit>();
      await cubit.createPaymentIntent(amount);

      if (!mounted) return;

      // Get client secret from cubit state
      final state = cubit.state;
      if (state is AddFundsSuccess) {
        final clientSecret = state.clientSecret;

        // Initialize payment sheet
        await stripe.Stripe.instance.initPaymentSheet(
          paymentSheetParameters: stripe.SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'UnisaEat',
            style: ThemeMode.system,
            googlePay: stripe.PaymentSheetGooglePay(
              merchantCountryCode: 'IT',
              testEnv: true,
            ),
          ),
        );

        // Present payment sheet
        await stripe.Stripe.instance.presentPaymentSheet();

        // On success, refresh wallet and user profile (force fresh data)
        if (mounted) {
          context.read<WalletCubit>().getData();
          // Force refresh user profile to bypass cache
          final userProfileCubit = context.read<UserProfileCubit>();
          userProfileCubit.getUser(forceRefresh: true);
          messenger.showSnackBar(
            const SnackBar(content: Text('Pagamento completato con successo!')),
          );
          Future.delayed(Duration.zero, () => context.pop());
        }
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Errore durante il pagamento: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddFundsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ricarica Portafoglio'),
          elevation: 0,
        ),
        body: BlocBuilder<AddFundsCubit, AddFundsState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Importo da ricaricare',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        prefixText: '€ ',
                        prefixStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci un importo';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount < 1.0) {
                          return 'Importo minimo €1.00';
                        }
                        if (amount > 500.0) {
                          return 'Importo massimo €500.00';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informazioni sul pagamento',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text('• Pagamento sicuro con Stripe'),
                            Text('• Carta di credito/debito accettate'),
                            Text('• Nessuna commissione aggiuntiva'),
                            Text('• Rimborso entro 24 ore se necessario'),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: state is AddFundsLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final amount = double.parse(amountController.text);
                                _processPayment(context, amount);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state is AddFundsLoading
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size: 24,
                            )
                           : Text(
                               AppLocalizations.of(context)!.pay_amount(amountController.text),
                               style: const TextStyle(fontSize: 18),
                             ),
                    ),
                    const SizedBox(height: 16),
                     Text(
                       'Test mode - Usa carta: 4242 4242 4242 4242',
                       style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12),
                       textAlign: TextAlign.center,
                     ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
