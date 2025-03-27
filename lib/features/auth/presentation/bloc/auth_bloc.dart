import 'package:expanse_tracker_app/core/error/failures.dart';
import 'package:expanse_tracker_app/core/storage/user_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_with_email_password.dart';
import '../../domain/usecases/sign_up_with_email_password.dart';
import '../../domain/usecases/sign_out.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../home/presentation/bloc/user_data_bloc.dart';
import '../../../home/presentation/bloc/user_data_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailPassword signInWithEmailPassword;
  final SignUpWithEmailPassword signUpWithEmailPassword;
  final GetCurrentUser getCurrentUser;
  final SignOut signOut;
  final UserDataBloc userDataBloc;

  AuthBloc({
    required this.signInWithEmailPassword,
    required this.signUpWithEmailPassword,
    required this.getCurrentUser,
    required this.signOut,
    required this.userDataBloc,
  }) : super(AuthInitial()) {
    on<SignInWithEmailPasswordEvent>(_onSignInWithEmailPassword);
    on<SignUpWithEmailPasswordEvent>(_onSignUpWithEmailPassword);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onSignInWithEmailPassword(
    SignInWithEmailPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await signInWithEmailPassword(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    
    result.fold(
      (failure) => emit(AuthError('Invalid email or password')),
      (user) {
        UserStorage.saveUserId(user.id);
        emit(Authenticated(user));
      },
    );
  }

  Future<void> _onSignUpWithEmailPassword(
    SignUpWithEmailPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await signUpWithEmailPassword(
      SignUpParams(
        email: event.email,
        password: event.password,
      ),
    );
    
    result.fold(
      (failure) {
        if (failure is EmailAlreadyInUseFailure) {
          emit(const AuthError('Email is already in use'));
        } else if (failure is WeakPasswordFailure) {
          emit(const AuthError('Password is too weak'));
        } else {
          emit(const AuthError('Failed to sign up'));
        }
      },
      (user) async {
        UserStorage.saveUserId(user.id);
        // Save salary to Firestore
        userDataBloc.add(
          SaveUserSalaryEvent(
            userId: user.id,
            salary: event.salary,
          ),
        );
        emit(Authenticated(user));
      },
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await getCurrentUser();
    
    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signOut();
    result.fold(
      (failure) => emit(AuthError('Failed to sign out')),
      (_) {
        UserStorage.clearUserId();
        emit(Unauthenticated());
      },
    );
  }
} 