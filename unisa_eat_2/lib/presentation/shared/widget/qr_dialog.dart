import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';
import 'package:unisa_eat_2/presentation/home/bloc/qr_code_cubit.dart';
import 'package:unisa_eat_2/presentation/home/bloc/qr_code_state.dart';

Widget qrCodeDialog(BuildContext context) {
    final qrCubit = QrcodeCubit()..startQrPolling();

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
                      color: Colors.grey.shade300,
                      
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
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(20),
                //   border: Border.all(width: 3, color: AppColors.primaryDark),
                // ),
                child: BlocBuilder<QrcodeCubit, QrcodeState>(
                  builder: (context, state) {
                    const double qrSize = 280; // bigger QR

                    if (state is QrcodeSuccess) {
                      return Column(
                        children: [
                          QrImageView(data: state.token, size: qrSize),
                          SizedBox(height: 23,),
                          LinearProgressIndicator(value: state.remainingTime / 5.0, color: AppColors.primaryDark,  minHeight: 4, backgroundColor: Colors.grey.shade300,),
                        ],
                      );
                    } else if (state is QrcodeLoading) {
                      return SizedBox(
                        height: qrSize,
                        width: qrSize,
                        child:  Center(child: LoadingAnimationWidget.newtonCradle(color: Theme.of(context).colorScheme.primary, size: 120)),
                      );
                    } else if (state is QrcodeError) {
                      return SizedBox(
                        height: qrSize,
                        width: qrSize,
                        child: const Center(child: Text('Error loading QR')),
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