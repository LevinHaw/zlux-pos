import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/income_entry/domain/entities/income_entry_entity.dart';

abstract class IncomeEntryRepository {
  Stream<List<IncomeEntryEntity>> watchIncomeEntries();

  Stream<List<IncomeEntryEntity>> watchIncomeEntriesByDate(DateTime date);

  Stream<List<DateTime>> watchIncomeDatesInMonth({
    required int year,
    required int month,
  });

  Future<IncomeEntryEntity?> getIncomeEntry(String id);

  Future<Result<IncomeEntryEntity>> saveIncomeEntry({
    String? id,
    required String incomeId,
    required String incomeName,
    required double amount,
    String note,
    required DateTime date,
  });

  Future<Result<void>> deleteIncomeEntry(String id);

  Future<void> syncPending();

  Future<Result<void>> pullAll();
}
