import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/auth/domain/repository/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;
  const SignOutUseCase(this._repository);
 
  Future<Result<void>> call() {
    return _repository.signOut();
  }
}