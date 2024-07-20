import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_soft_app/core/strings/texts.dart';
import 'package:progress_soft_app/features/post/presentation/bloc/posts_bloc.dart';

import '../../../core/features/index/presentation/screens/index_screen.dart';
import '../../../core/features/settings/presentation/bloc/settings_bloc.dart';
import '../../../core/strings/images.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded) {
            context.read<AuthBloc>().add(AppStarted());
          }
        },
        child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              log(state.toString());
              Future.delayed(const Duration(seconds: 2), () {
                if (state is AuthAuthenticated) {
                  context.read<PostsBloc>().add(FetchPostsEvent());
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      const IndexScreen()), (Route<dynamic> route) => false);
                } else if (state is AuthUnauthenticated) {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
                }
              });
            },
        child: Center(
          child: SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                SvgPicture.asset(
                  kLogoImage,
                  width: 250,
                  fit: BoxFit.fitWidth,
                ),
                const SafeArea(child: Text(COPY_RIGHT, textAlign: TextAlign.center))
              ],
            ),
          ),
        ),
        )
      ),
    );
  }
}