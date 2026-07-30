import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/income/domain/entities/income_entity.dart';
import 'package:zlux_pos/features/setup/income/domain/repository/income_repository.dart';

class SaveIncomeUsecase {
  final IncomeRepository _repository;

  const SaveIncomeUsecase(this._repository);

  Future<Result<IncomeEntity>> call({String? id, required String name}) {
    return _repository.saveIncome(id: id, name: name);
  }
}
