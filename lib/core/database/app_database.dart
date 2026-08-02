import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:zlux_pos/core/database/dao/category_dao.dart';
import 'package:zlux_pos/core/database/dao/expense_dao.dart';
import 'package:zlux_pos/core/database/dao/income_dao.dart';
import 'package:zlux_pos/core/database/dao/orders_dao.dart';
import 'package:zlux_pos/core/database/dao/product_dao.dart';
import 'package:zlux_pos/core/database/table/category_table.dart';
import 'package:zlux_pos/core/database/table/expense_table.dart';
import 'package:zlux_pos/core/database/table/income_table.dart';
import 'package:zlux_pos/core/database/table/orders_item_table.dart';
import 'package:zlux_pos/core/database/table/orders_table.dart';
import 'package:zlux_pos/core/database/table/product_table.dart';

import 'dao/expense_entry_dao.dart';
import 'dao/income_entry_dao.dart';
import 'dao/daily_report_note_dao.dart';
import 'table/expense_entries_table.dart';
import 'table/income_entries_table.dart';
import 'table/daily_report_notes_table.dart';


part 'app_database.g.dart';

@DriftDatabase(
  tables: [Product, Category, Orders, OrderItems, Income, Expense, IncomeEntries, ExpenseEntries, DailyReportNotes],
  daos: [ProductDao, CategoryDao, OrdersDao, IncomeDao, ExpenseDao, IncomeEntryDao, ExpenseEntryDao, DailyReportNoteDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(orders);
            await m.createTable(orderItems);
          }
          if (from < 3) {
            await m.addColumn(orders, orders.paymentMethod);
          }
          if (from < 4) {
            await m.addColumn(orderItems, orderItems.productId);
          }
          if (from < 5) {
            await m.createTable(income);
          }
          if (from < 6) {
            await m.createTable(dailyReportNotes);
          }
        },
      );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'zlux_pos.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
