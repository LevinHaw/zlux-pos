import '../entities/income_entry_entity.dart';
import '../repository/income_entry_repository.dart';

class WatchIncomeEntriesByDateUsecase {
  final IncomeEntryRepository _repository;

  const WatchIncomeEntriesByDateUsecase(this._repository);

  Stream<List<IncomeEntryEntity>> call(DateTime date) =>
      _repository.watchIncomeEntriesByDate(date);
}
