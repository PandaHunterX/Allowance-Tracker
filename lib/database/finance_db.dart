import 'package:productivity_app/database/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/category.dart';
import '../models/expense_item.dart';
import '../models/categories.dart';

const uuid = Uuid();

class FinanceDB {
  final tableName = 'expenses';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "expense" REAL NOT NULL,
    "category" TEXT,
    "date_time" TEXT,
    PRIMARY KEY("id")
    );""");
  }

  Future<int> create(
      {required String name,
        required double expense,
        required Category category}) async {
    final database = await DatabaseService().database;

    return await database.rawInsert(
      '''INSERT INTO $tableName (id, name, expense, category, date_time)
       VALUES (?, ?, ?, ?, ?)''',
      [
        uuid.v4(),
        name,
        expense,
        category.title,
        DateTime.now().toIso8601String(),
      ],
    );
  }

  Future<List<ExpenseItem>> fetchAll() async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await database.query(tableName);

    return List.generate(maps.length, (i) {
      return ExpenseItem(
        name: maps[i]['name'],
        expense: maps[i]['expense'],
        category: categories.entries
            .firstWhere((entry) => entry.value.title == maps[i]['category'])
            .value,
        dateTime: DateTime.parse(maps[i]['date_time']),
      );
    });
  }
}