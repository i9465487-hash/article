import '../../data/auh_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class SignUpLoading extends LoginState {}

class SignUpSuccess extends LoginState {
  final UserModel user;

  SignUpSuccess(this.user);
}

class SignUpFailure extends LoginState {
  final String error;
  SignUpFailure(this.error);
}