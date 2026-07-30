import 'dart:io';

import 'package:zlux_pos/features/setup/data/datasource/setup_remote_datasource.dart';
import 'package:zlux_pos/features/setup/domain/entities/merchant_entity.dart';
import 'package:zlux_pos/features/setup/domain/repository/setup_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';

class SetupRepositoryImpl implements SetupRepository {
  final SetupRemoteDataSource _remoteDataSource;

  const SetupRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<MerchantEntity>> saveMerchant({
    required String name,
    required String address,
    File? imageFile,
  }) async {
    try {
      final model = await _remoteDataSource.saveMerchant(
        name: name,
        address: address,
        imageFile: imageFile,
      );
      return Success(model);
    } on AuthException catch (e) {
      return ResultFailure(AuthFailure(e.message));
    } on ServerException catch (e) {
      return ResultFailure(ServerFailure(e.message));
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<MerchantEntity?>> getMerchant() async {
    try {
      final model = await _remoteDataSource.getMerchant();
      return Success(model);
    } on AuthException catch (e) {
      return ResultFailure(AuthFailure(e.message));
    } on ServerException catch (e) {
      return ResultFailure(ServerFailure(e.message));
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }
}
