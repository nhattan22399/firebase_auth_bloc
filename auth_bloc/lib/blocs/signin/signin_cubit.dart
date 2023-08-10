import 'package:auth_bloc/models/custom_error.dart';
import 'package:auth_bloc/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository authRepository;
  SigninCubit({ required this.authRepository }) : super(SigninState.initialize());

  Future<void> signin({
    required String email,
    required String password
  }) async {
    emit(state.copyWith(signinStatus: SignStatus.submitting));

    try{
      await authRepository.signin(email: email, password: password);

      emit(state.copyWith(signinStatus: SignStatus.success));
    } on CustomError catch(e) {
      emit(
        state.copyWith(signinStatus: SignStatus.error, error: e),
      );
    }
  }
}
