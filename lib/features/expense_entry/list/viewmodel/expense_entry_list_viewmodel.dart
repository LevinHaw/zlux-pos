import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/expense_entry/domain/entities/expense_entry_entity.dart';
import 'package:zlux_pos/features/expense_entry/presentation/provider/expense_entry_provider.dart';

part 'expense_entry_list_viewmodel.g.dart';

@riverpod
class ExpenseEntryListViewModel extends _$ExpenseEntryListViewModel {
  @override
  Stream<List<ExpenseEntryEntity>> build() {
    return ref.watch(watchExpenseEntriesUsecaseProvider)();
  }
}
