import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/setup/income/domain/entities/income_entity.dart';
import 'package:zlux_pos/features/setup/income/presentation/provider/income_provider.dart';

part 'setup_income_viewmodel.g.dart';

@riverpod
class SetupIncomeViewModel extends _$SetupIncomeViewModel {
  @override
  Stream<List<IncomeEntity>> build() {
    return ref.watch(watchIncomeUsecaseProvider)();
  }
}