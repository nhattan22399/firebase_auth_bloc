// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'signin_cubit.dart';

enum SignStatus{
  initial,
  submitting,
  success,
  error
}

class SigninState extends Equatable {
  final SignStatus signinStatus;
  final CustomError error;
  SigninState({
    required this.signinStatus,
    required this.error,
  });

  factory SigninState.initialize(){
    return SigninState(signinStatus: SignStatus.initial, error: CustomError());
  }
  
  @override
  List<Object?> get props => [signinStatus, error];

  @override
  String toString() => 'signinState(signinStatus: $signinStatus, error: $error)';

  

  SigninState copyWith({
    SignStatus? signinStatus,
    CustomError? error,
  }) {
    return SigninState(
      signinStatus: signinStatus ?? this.signinStatus,
      error: error ?? this.error,
    );
  }
}
