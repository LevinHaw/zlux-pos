import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/income_entry/domain/repository/income_entry_repository.dart';

class DeleteIncomeEntryUsecase {
  final IncomeEntryRepository _repository;

  const DeleteIncomeEntryUsecase(this._repository);

  Future<Result<void>> call(String id) => _repository.deleteIncomeEntry(id);
}
