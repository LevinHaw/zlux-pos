import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/income/domain/entities/income_entity.dart';

abstract class IncomeRepository {
  Stream<List<IncomeEntity>> watchIncomeItem();

  Future<IncomeEntity?> getIncomeItem(String id);

  Future<Result<IncomeEntity>> saveIncome({
    String? id,
    required String name,
  });

  Future<Result<void>> deleteIncome(String id);

  Future<void> syncPending();

  Future<Result<void>> pullAll();
}
