import 'dart:io';

import '../../../../core/utils/result.dart';
import '../entities/merchant_entity.dart';

abstract class SetupRepository {
  Future<Result<MerchantEntity>> saveMerchant({
    required String name,
    required String address,
    File? imageFile,
  });

  Future<Result<MerchantEntity?>> getMerchant();
}
