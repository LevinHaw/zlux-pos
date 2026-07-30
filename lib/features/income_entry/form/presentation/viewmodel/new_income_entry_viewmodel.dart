import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/income_entry/domain/entities/income_entry_entity.dart';
import 'package:zlux_pos/features/income_entry/presentation/provider/income_entry_provider.dart';

part 'new_income_entry_viewmodel.g.dart';

class NewIncomeEntryState {
  final IncomeEntryEntity? initial;
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;

  const NewIncomeEntryState({
    this.initial,
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
  });

  NewIncomeEntryState copyWith({
    IncomeEntryEntity? initial,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
  }) {
    return NewIncomeEntryState(
      initial: initial ?? this.initial,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class NewIncomeEntryViewModel extends _$NewIncomeEntryViewModel {
  @override
  Future<NewIncomeEntryState> build(String? entryId) async {
    IncomeEntryEntity? initial;
    if (entryId != null) {
      final repository = ref.watch(incomeEntryRepositoryProvider);
      initial = await repository.getIncomeEntry(entryId);
    }
    return NewIncomeEntryState(initial: initial);
  }

  Future<void> save({
    required String incomeId,
    required String incomeName,
    required double amount,
    String note = '',
    required DateTime date,
  }) async {
    final current = state.valueOrNull ?? const NewIncomeEntryState();
    state = AsyncData(current.copyWith(isLoading: true, errorMessage: null));

    final usecase = ref.read(saveIncomeEntryUsecaseProvider);
    final result = await usecase(
      id: current.initial?.id,
      incomeId: incomeId,
      incomeName: incomeName,
      amount: amount,
      note: note.trim(),
      date: date,
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
