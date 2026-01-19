import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';
import 'package:unisa_eat_2/presentation/home/bloc/qr_code_cubit.dart';
import 'package:unisa_eat_2/presentation/home/bloc/qr_code_state.dart';

class QrCodeDialog extends StatelessWidget {
  const QrCodeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final qrCubit = QrCodeCubit()..startQrPolling();

    return BlocProvider.value(
      value: qrCubit,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '',
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       color: Theme.of(context).colorScheme.surfaceContainerHighest,
                     ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 20,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        qrCubit.close();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<QrCodeCubit, QrCodeState>(
                  builder: (context, state) {
                    const double qrSize = 280;

                     if (state is QrCodeSuccess) {
                       return Column(
                         children: [
                           QrImageView(
                             data: state.token,
                             size: qrSize,
                             backgroundColor: Colors.white,
                           ),
                           SizedBox(height: 23,),
                            LinearProgressIndicator(value: state.remainingTime / 5.0, color: AppColors.primaryDark,  minHeight: 4, backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,),
                         ],
                       );
                     }
                    return SizedBox(height: qrSize, width: qrSize);
                  },
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Scan this code at checkout to complete your purchase.',
                textAlign: TextAlign.center,
              ),


            ],

          ),
        ),
      ),
    );
  }
}