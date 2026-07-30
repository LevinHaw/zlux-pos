import 'dart:io';

import 'package:zlux_pos/features/setup/domain/repository/setup_repository.dart';

import '../../../../core/utils/result.dart';
import '../entities/merchant_entity.dart';

class SaveMerchantUsecase {
  final SetupRepository _repository;

  const SaveMerchantUsecase(this._repository);

  Future<Result<MerchantEntity>> call({
    required String name,
    required String address,
    File? imageFile,
  }) {
    return _repository.saveMerchant(
      name: name,
      address: address,
      imageFile: imageFile,
    );
  }
}
