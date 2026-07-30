import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/expense_entry/domain/entities/expense_entry_entity.dart';
import 'package:zlux_pos/features/expense_entry/presentation/provider/expense_entry_provider.dart';

part 'new_expense_entry_viewmodel.g.dart';

class NewExpenseEntryState {
  final ExpenseEntryEntity? initial;
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;

  const NewExpenseEntryState({
    this.initial,
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
  });

  NewExpenseEntryState copyWith({
    ExpenseEntryEntity? initial,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
  }) {
    return NewExpenseEntryState(
      initial: initial ?? this.initial,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class NewExpenseEntryViewModel extends _$NewExpenseEntryViewModel {
  @override
  Future<NewExpenseEntryState> build(String? entryId) async {
    ExpenseEntryEntity? initial;
    if (entryId != null) {
      final repository = ref.watch(expenseEntryRepositoryProvider);
      initial = await repository.getExpenseEntry(entryId);
    }
    return NewExpenseEntryState(initial: initial);
  }

  Future<void> save({
    required String expenseId,
    required String expenseName,
    required double amount,
    String note = '',
    required DateTime date,
  }) async {
    final current = state.valueOrNull ?? const NewExpenseEntryState();
    state = AsyncData(current.copyWith(isLoading: true, errorMessage: null));

    final usecase = ref.read(saveExpenseEntryUsecaseProvider);
    final result = await usecase(
      id: current.initial?.id,
      expenseId: expenseId,
      expenseName: expenseName,
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
