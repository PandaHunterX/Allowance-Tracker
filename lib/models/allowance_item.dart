import 'package:uuid/uuid.dart';
import 'category.dart';

const uuid = Uuid();

class AllowanceItem {
  final String id;
  final String description;
  final double amount;
  final AllowanceCategory category;
  final DateTime dateTime;

  AllowanceItem({ required this.description, required this.amount, required this.category, required this.dateTime}): id = uuid.v4();
}