import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/core/configs/assets/images.dart';

import 'package:unisa_eat_2/presentation/shared/widget/qr_dialog.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_state.dart';
import 'package:unisa_eat_2/presentation/shared/widget/tappable_image.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(color: Colors.transparent),
                  ),

                  Center(child: qrCodeDialog(context)),
                ],
              );
            },
          );
        },
        child: Icon(Icons.qr_code_scanner_outlined),
      ),
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileSuccess) {
            final user = state.user;
            return Container(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning, ${user.nome}!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 10),
            
                  SizedBox(height: 10),
                  TappableImageCard(assetImagePath: AppImages.todayMenuImage, overlayText: "Today's Menu", routePath: '/menu', subtitleText: "Tap To See What's Cooking!"),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  
}
