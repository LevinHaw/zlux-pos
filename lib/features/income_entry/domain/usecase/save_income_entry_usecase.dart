import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/income_entry/domain/entities/income_entry_entity.dart';
import 'package:zlux_pos/features/income_entry/domain/repository/income_entry_repository.dart';

class SaveIncomeEntryUsecase {
  final IncomeEntryRepository _repository;

  const SaveIncomeEntryUsecase(this._repository);

  Future<Result<IncomeEntryEntity>> call({
    String? id,
    required String incomeId,
    required String incomeName,
    required double amount,
    String note = '',
    required DateTime date,
  }) {
    return _repository.saveIncomeEntry(
      id: id,
      incomeId: incomeId,
      incomeName: incomeName,
      amount: amount,
      note: note,
      date: date,
    );
  }
}
