import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/storage/user_storage.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/home/presentation/bloc/user_data_bloc.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      await UserStorage.init(); // Initialize Hive
      await di.init(); // Initialize dependency injection
      
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        UserStorage.svaeFcmToken(fcmToken ?? '');
      }
      //Pass all uncaught errors from the framework to Crashlytics.
      FlutterError.onError = (details) {
        FirebaseCrashlytics.instance.recordFlutterError(details);
        FlutterError.presentError(details);
      };
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
      ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
        FlutterError.presentError(errorDetails);
        return const IgnorePointer();
      };
      runApp(const MyApp());
    },
    (error, stack) {
      FirebaseCrashlytics.instance.log('Error: $error');
      FirebaseCrashlytics.instance.recordError(error, stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider<UserDataBloc>(
          create: (_) => di.sl<UserDataBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}