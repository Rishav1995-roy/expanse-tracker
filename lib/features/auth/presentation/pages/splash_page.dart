import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';
import '../../../home/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Check authentication status when the splash screen is initialized
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else if (state is Unauthenticated) {
            // Navigate to login page if not authenticated
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Icon(
                Icons.account_balance_wallet,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),
              const Text(
                'Expense Tracker',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
} 