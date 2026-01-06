import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddFundsPage extends StatefulWidget {
  const AddFundsPage({super.key});

  @override
  State<AddFundsPage> createState() => _AddFundsPageState();
}

class _AddFundsPageState extends State<AddFundsPage> {
  final TextEditingController amountController = TextEditingController();

  

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    amountController.text = '5';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ricarica Portafoglio'),
        elevation: 0,
      ),
      body: Padding(padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            
              
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
            inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
            controller: amountController,
            decoration: const InputDecoration(
              labelText: 'Importo da ricaricare',
              
            ),
          ),
        ],
      ) ,)
      
    );
  }
}
