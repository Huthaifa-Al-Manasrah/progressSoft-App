import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_soft_app/features/post/presentation/bloc/posts_bloc.dart';

import 'core/features/settings/presentation/bloc/settings_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SettingsBloc>()..add(LoadSettings()),
        ),
        BlocProvider(
          create: (context) => sl<AuthBloc>()..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => sl<PostsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Progress Soft App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
