import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/setup/presentation/provider/setup_provider.dart';

import '../../../../../core/utils/result.dart';
part 'setup_merchant_viewmodel.g.dart';

class SetupMerchantState {
  final File? imageFile;
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;

  const SetupMerchantState({
    this.imageFile,
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
  });

  SetupMerchantState copyWith({
    File? imageFile,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
  }) {
    return SetupMerchantState(
      imageFile: imageFile ?? this.imageFile,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class SetupMerchantViewModel extends _$SetupMerchantViewModel {
  @override
  SetupMerchantState build() => const SetupMerchantState();

  void setImage(File file) {
    state = state.copyWith(imageFile: file);
  }

  Future<void> save({
    required String name,
    required String address,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final usecase = ref.read(saveMerchantUsecaseProvider);
    final result = await usecase(
      name: name.trim(),
      address: address.trim(),
      imageFile: state.imageFile,
    );

    switch (result) {
      case Success():
        state = state.copyWith(isLoading: false, isSaved: true);
      case ResultFailure(:final failure):
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
    }
  }
}
