import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/expense/domain/entities/expense_entity.dart';

abstract class ExpenseRepository {
  Stream<List<ExpenseEntity>> watchExpenseItem();

  Future<ExpenseEntity?> getExpenseItem(String id);

  Future<Result<ExpenseEntity>> saveExpense({
    String? id,
    required String name,
  });

  Future<Result<void>> deleteExpense(String id);

  Future<void> syncPending();

  Future<Result<void>> pullAll();
}