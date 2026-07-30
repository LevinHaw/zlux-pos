import 'package:zlux_pos/features/income_entry/domain/entities/income_entry_entity.dart';
import 'package:zlux_pos/features/income_entry/domain/repository/income_entry_repository.dart';

class WatchIncomeEntriesUsecase {
  final IncomeEntryRepository _repository;

  const WatchIncomeEntriesUsecase(this._repository);

  Stream<List<IncomeEntryEntity>> call() => _repository.watchIncomeEntries();
}
