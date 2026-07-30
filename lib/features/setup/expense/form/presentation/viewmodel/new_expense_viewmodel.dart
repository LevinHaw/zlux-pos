import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/utils/result.dart';
import '../../../domain/entities/expense_entity.dart';
import '../../../presentation/provider/expense_provider.dart';

part 'new_expense_viewmodel.g.dart';

class NewExpenseState {
  final ExpenseEntity? initial;
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;

  const NewExpenseState({
    this.initial,
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
  });

  NewExpenseState copyWith({
    ExpenseEntity? initial,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
  }) {
    return NewExpenseState(
      initial: initial ?? this.initial,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class NewExpenseViewModel extends _$NewExpenseViewModel {
  @override
  Future<NewExpenseState> build(String? expenseId) async {
    ExpenseEntity? initial;
    if (expenseId != null) {
      final repository = ref.watch(expenseRepositoryProvider);
      initial = await repository.getExpenseItem(expenseId);
    }
    return NewExpenseState(initial: initial);
  }

  Future<void> save({required String name}) async {
    final current = state.valueOrNull ?? const NewExpenseState();
    state = AsyncData(current.copyWith(isLoading: true, errorMessage: null));

    final usecase = ref.read(saveExpenseUsecaseProvider);
    final result = await usecase(id: current.initial?.id, name: name.trim());

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
  