import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:unisa_eat_2/payment_configurations.dart';

class PaymentTestPage extends StatefulWidget {
  const PaymentTestPage({super.key});

  @override
  State<PaymentTestPage> createState() => _PaymentTestPageState();
}

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

class _PaymentTestPageState extends State<PaymentTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GooglePayButton(
        paymentConfiguration: defaultGooglePayConfig,
        paymentItems: _paymentItems,
        type: GooglePayButtonType.buy,
        margin: const EdgeInsets.only(top: 15.0),
        onPaymentResult: onGooglePayResult,
        loadingIndicator: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void onGooglePayResult(Map<String, dynamic> paymentResult) {
  
  print(paymentResult);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Google Pay payment successfully completed')
    ),
  );
}

}