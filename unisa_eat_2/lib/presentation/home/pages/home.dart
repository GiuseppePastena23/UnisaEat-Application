import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unisa_eat_2/presentation/home/bloc/qr_code_cubit.dart';
import 'package:unisa_eat_2/presentation/home/bloc/qr_code_state.dart';
import 'package:unisa_eat_2/presentation/shared/widget/custom_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrcodeCubit()..startQrPolling(),
      child: BlocBuilder<QrcodeCubit, QrcodeState>(
        builder: (context, state) {
          Widget content;

          if (state is QrcodeInitial) {
            content = Text('Qr Code');
          }
  
          else if (state is QrcodeLoading) {
            content = CircularProgressIndicator();
          } else if (state is QrcodeSuccess) {
            content = QrImageView(
              data: state.token,
              version: QrVersions.auto,
              size: 300.0, 
            );
          } else if (state is QrcodeError) {
            content = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 8),
                Text(state.message, textAlign: TextAlign.center),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<QrcodeCubit>().startQrPolling(),
                  child: Text('Riprova'),
                ),
              ],
            );
          } else {
            content = SizedBox.shrink();
          }
          return Center(
            child: CustomCard(
              child: content
            ),
          );
        },
      ),
    );
  }
}
