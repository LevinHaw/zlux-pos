import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/auth/domain/entities/user_entity.dart';
import 'package:zlux_pos/features/auth/domain/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  const SignUpUseCase(this._repository);
 
  Future<Result<UserEntity>> call({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) {
    return _repository.signUp(
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
  }
}