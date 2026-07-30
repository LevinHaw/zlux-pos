import 'package:zlux_pos/features/setup/income/domain/entities/income_entity.dart';
import 'package:zlux_pos/features/setup/income/domain/repository/income_repository.dart';

class WatchIncomeUsecase {
  final IncomeRepository _repository;

  const WatchIncomeUsecase(this._repository);

  Stream<List<IncomeEntity>> call() => _repository.watchIncomeItem();
}
