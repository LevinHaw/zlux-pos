import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/expense/domain/entities/expense_entity.dart';
import 'package:zlux_pos/features/setup/expense/domain/repository/expense_repository.dart';

class SaveExpenseUsecase {
  final ExpenseRepository _repository;

  const SaveExpenseUsecase(this._repository);

  Future<Result<ExpenseEntity>> call({String? id, required String name}) {
    return _repository.saveExpense(id: id, name: name);
  }
}