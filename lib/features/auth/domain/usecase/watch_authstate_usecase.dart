import 'package:zlux_pos/features/auth/domain/repository/auth_repository.dart';

import '../entities/user_entity.dart';

class WatchAuthStateUseCase {
  final AuthRepository _repository;
  const WatchAuthStateUseCase(this._repository);

  Stream<UserEntity?> call() {
    return _repository.watchAuthState();
  }
}