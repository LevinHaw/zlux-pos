import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/expense_entity.dart';
import '../../presentation/provider/expense_provider.dart';

part 'setup_expense_viewmodel.g.dart';

@riverpod
class SetupExpenseViewModel extends _$SetupExpenseViewModel {
  @override
  Stream<List<ExpenseEntity>> build() {
    return ref.watch(watchExpenseUsecaseProvider)();
  }
}