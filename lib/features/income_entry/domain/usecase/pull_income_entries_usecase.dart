import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/income_entry/domain/repository/income_entry_repository.dart';

class PullIncomeEntriesUsecase {
  final IncomeEntryRepository _repository;

  const PullIncomeEntriesUsecase(this._repository);

  Future<Result<void>> call() => _repository.pullAll();
}
