import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/income_entry/domain/entities/income_entry_entity.dart';
import 'package:zlux_pos/features/income_entry/presentation/provider/income_entry_provider.dart';

part 'income_entry_list_viewmodel.g.dart';

@riverpod
class IncomeEntryListViewModel extends _$IncomeEntryListViewModel {
  @override
  Stream<List<IncomeEntryEntity>> build() {
    return ref.watch(watchIncomeEntriesUsecaseProvider)();
  }
}
