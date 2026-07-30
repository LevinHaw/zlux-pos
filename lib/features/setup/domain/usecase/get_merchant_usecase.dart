import 'package:zlux_pos/features/setup/domain/repository/setup_repository.dart';

import '../../../../core/utils/result.dart';
import '../entities/merchant_entity.dart';

class GetMerchantUsecase {
  final SetupRepository _repository;

  const GetMerchantUsecase(this._repository);

  Future<Result<MerchantEntity?>> call() {
    return _repository.getMerchant();
  }
}
