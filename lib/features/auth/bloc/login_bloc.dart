import 'package:ecommerce_app/features/auth/bloc/login_event.dart';
import 'package:ecommerce_app/features/auth/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginInitial()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(const LoginSuccess());
  }
}
