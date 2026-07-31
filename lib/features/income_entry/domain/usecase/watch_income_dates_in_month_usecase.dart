import '../repository/income_entry_repository.dart';

class WatchIncomeDatesInMonthUsecase {
  final IncomeEntryRepository _repository;

  const WatchIncomeDatesInMonthUsecase(this._repository);

  Stream<List<DateTime>> call({required int year, required int month}) {
    return _repository.watchIncomeDatesInMonth(year: year, month: month);
  }
}