import 'package:productivity_app/database/database_service.dart';
import 'package:productivity_app/models/allowance_item.dart';
import 'package:productivity_app/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/category.dart';
import '../models/expense_item.dart';
import '../models/categories.dart';

const uuid = Uuid();

class FinanceDB {
  final expenseTable = 'expenses';
  final allowanceTable = 'allowances';
  final userTable = 'user';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $userTable (
    "id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "allowance" REAL NOT NULL,
    PRIMARY KEY ("id")
    );""");

    await database.execute("""CREATE TABLE IF NOT EXISTS $expenseTable (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "expense" REAL NOT NULL,
    "category" TEXT,
    "date_time" TEXT,
    PRIMARY KEY("id")
    );""");

    await database.execute("""CREATE TABLE IF NOT EXISTS $allowanceTable (
    "id" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "amount" REAL NOT NULL,
    "category" TEXT,
    "date_time" TEXT,
    PRIMARY KEY("id")
    );""");

    await database.execute("""INSERT INTO $userTable (id, username, allowance) VALUES ('1', 'Username', 0.0)""");
  }

  Future<int> createExpenses(
      {required String name,
      required double expense,
      required ExpenseCategory category}) async {
    final database = await DatabaseService().database;

    return await database.rawInsert(
      '''INSERT INTO $expenseTable (id, name, expense, category, date_time)
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

  Future<int> createAllowance(
      {required String description,
      required double amount,
      required AllowanceCategory category}) async {
    final database = await DatabaseService().database;

    return await database.rawInsert(
        '''INSERT INTO $allowanceTable (id, description, amount, category, date_time) VALUES (?, ?, ?, ?, ?)''',
        [
          uuid.v4(),
          description,
          amount,
          category.title,
          DateTime.now().toIso8601String(),
        ]);
  }

  Future<User> fetchUser() async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> db = await database.query(userTable);
    final user = db.first;

    return User(username: user['username'], allowance: user['allowance']);
  }

  Future<int> updateAllowance(double allowance) async {
    final database = await DatabaseService().database;
    return await database.update(userTable, {'allowance': allowance},
        where: 'id = ?', whereArgs: ['1']);
  }

  Future<List<ExpenseItem>> fetchExpense() async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await database.query(expenseTable);

    return List.generate(maps.length, (i) {
      return ExpenseItem(
        name: maps[i]['name'],
        expense: maps[i]['expense'],
        category: expense_categories.entries
            .firstWhere((entry) => entry.value.title == maps[i]['category'])
            .value,
        dateTime: DateTime.parse(maps[i]['date_time']),
      );
    });
  }

  Future<List<AllowanceItem>> fetchAllowance() async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> maps =
        await database.query(allowanceTable);

    return List.generate(maps.length, (i) {
      return AllowanceItem(
        description: maps[i]['description'],
        amount: maps[i]['amount'],
        category: allowance_categories.entries
            .firstWhere((entry) => entry.value.title == maps[i]['category'])
            .value,
        dateTime: DateTime.parse(maps[i]['date_time']),
      );
    });
  }
}
