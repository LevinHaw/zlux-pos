import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/income/domain/entities/income_entity.dart';
import 'package:zlux_pos/features/setup/income/presentation/provider/income_provider.dart';

part 'new_income_viewmodel.g.dart';

class NewIncomeState {
  final IncomeEntity? initial;
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;

  const NewIncomeState({
    this.initial,
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
  });

  NewIncomeState copyWith({
    IncomeEntity? initial,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
  }) {
    return NewIncomeState(
      initial: initial ?? this.initial,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class NewIncomeViewModel extends _$NewIncomeViewModel {

  @override
  Future<NewIncomeState> build(String? incomeId) async {
    IncomeEntity? initial;
    if (incomeId != null) {
      final repository = ref.watch(incomeRepositoryProvider);
      initial = await repository.getIncomeItem(incomeId);
    }
    return NewIncomeState(initial: initial);
  }

  Future<void> save({
    required String name,
  }) async {
    final current = state.valueOrNull ?? const NewIncomeState();
    state = AsyncData(current.copyWith(isLoading: true, errorMessage: null));

    final usecase = ref.read(saveIncomeUsecaseProvider);
    final result = await usecase(
      id: current.initial?.id,
      name: name.trim(),
    );

    switch (result) {
      case Success():
        state = AsyncData(current.copyWith(isLoading: false, isSaved: true));
      case ResultFailure(:final failure):
        state = AsyncData(
          current.copyWith(isLoading: false, errorMessage: failure.message),
        );
    }
  }
}
