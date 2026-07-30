import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/setup/data/datasource/setup_remote_datasource.dart';
import 'package:zlux_pos/features/setup/data/repository/setup_repository_impl.dart';
import 'package:zlux_pos/features/setup/domain/repository/setup_repository.dart';
import 'package:zlux_pos/features/setup/domain/usecase/get_merchant_usecase.dart';
import 'package:zlux_pos/features/setup/domain/usecase/save_merchant_usecase.dart';

part 'setup_provider.g.dart';

@riverpod
SetupRemoteDataSource setupRemoteDataSource(SetupRemoteDataSourceRef ref) {
  return SetupRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    storage: FirebaseStorage.instance,
  );
}

@riverpod
SetupRepository setupRepository(SetupRepositoryRef ref) {
  return SetupRepositoryImpl(ref.watch(setupRemoteDataSourceProvider));
}

@riverpod
SaveMerchantUsecase saveMerchantUsecase(SaveMerchantUsecaseRef ref) {
  return SaveMerchantUsecase(ref.watch(setupRepositoryProvider));
}

@riverpod
GetMerchantUsecase getMerchantUsecase(GetMerchantUsecaseRef ref) {
  return GetMerchantUsecase(ref.watch(setupRepositoryProvider));
}
