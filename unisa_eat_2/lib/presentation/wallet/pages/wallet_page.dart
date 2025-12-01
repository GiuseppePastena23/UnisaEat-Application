import 'package:flutter/material.dart';
import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          // Balance

          _balance(context),

          

          // Recent Transactions
          _recentTransactions(context),






        ],

        
      )

    );
  }

  Widget _balance(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, right: 25, left: 25),
      alignment: Alignment.center,
      child: Column(
        
        children: [
          Text('Current Balance', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('€${50.00.toStringAsPrecision(4)}', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(width: 10),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: AppColors.balanceIconBackground,
                  shape: BoxShape.circle,),
                child: IconButton(onPressed: () { }, icon: Icon(Icons.add), padding: EdgeInsets.zero,),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
        ]),
    );
  }

  Widget _recentTransactions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
            ],
          ),
        ],
      )

    );
  }
}

