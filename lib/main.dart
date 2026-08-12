import 'package:contractor_app/core/theme/app_theme.dart';
import 'package:contractor_app/features/auth/data/repository/auth_repository.dart';
import 'package:contractor_app/features/auth/data/services/auth_session_store.dart';
import 'package:contractor_app/features/auth/view/login_screen.dart';
import 'package:contractor_app/features/home/presentation/home_shell.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/bloc/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthSessionStore.instance.restore();
  runApp(
    DevicePreview(enabled: true, builder: (context) => const ContractorApp()),
  );
}

class ContractorApp extends StatelessWidget {
  const ContractorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthRepository())),
      ],
      child: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contractor & Sub Contractor Manager',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      // MaterialApp's `builder` callback runs with a context that's
      // already inside MediaQuery (WidgetsApp sets that up above us), so
      // this is where we can safely call AppTheme.light(context) and have
      // Responsive() correctly read the screen width.
      theme: AppTheme.build(context),
      home: AuthSessionStore.instance.isLoggedIn
          ? const HomeShell()
          : const LoginScreen(),
    );
  }
}