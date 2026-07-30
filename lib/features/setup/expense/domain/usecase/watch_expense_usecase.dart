import 'package:zlux_pos/features/setup/expense/domain/entities/expense_entity.dart';
import 'package:zlux_pos/features/setup/expense/domain/repository/expense_repository.dart';

class WatchExpenseUsecase {
  final ExpenseRepository _repository;

  const WatchExpenseUsecase(this._repository);

  Stream<List<ExpenseEntity>> call()=> _repository.watchExpenseItem();
}