import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/sign_in_with_email_password.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up_with_email_password.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/data/datasources/user_data_remote_data_source.dart';
import '../../features/home/data/repositories/user_data_repository_impl.dart';
import '../../features/home/domain/repositories/user_data_repository.dart';
import '../../features/home/domain/usecases/load_user_data.dart';
import '../../features/home/domain/usecases/load_user_salary.dart';
import '../../features/home/domain/usecases/save_expense.dart';
import '../../features/home/domain/usecases/save_user_salary.dart';
import '../../features/home/presentation/bloc/user_data_bloc.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Bloc
  sl.registerFactory(
    () => UserDataBloc(
      saveUserSalary: sl(),
      loadUserSalary: sl(),
      saveExpense: sl(),
      loadUserData: sl(),
    ),
  );

  sl.registerFactory(
    () => AuthBloc(
      signInWithEmailPassword: sl(),
      signUpWithEmailPassword: sl(),
      getCurrentUser: sl(),
      signOut: sl(),
      userDataBloc: sl<UserDataBloc>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInWithEmailPassword(sl()));
  sl.registerLazySingleton(() => SignUpWithEmailPassword(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => SaveUserSalary(sl()));
  sl.registerLazySingleton(() => LoadUserSalary(sl()));
  sl.registerLazySingleton(() => SaveExpense(sl()));
  sl.registerLazySingleton(() => LoadUserData(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<UserDataRepository>(
    () => UserDataRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
    ),
  );

  sl.registerLazySingleton<UserDataRemoteDataSource>(
    () => UserDataRemoteDataSourceImpl(
      firestore: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
