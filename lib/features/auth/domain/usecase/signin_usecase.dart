import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/auth/domain/entities/user_entity.dart';
import 'package:zlux_pos/features/auth/domain/repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;
  const SignInUseCase(this._repository);
 
  Future<Result<UserEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}