import '../category model/category.dart';

class AllowanceItem {
  final String id;
  final String description;
  final double amount;
  final AllowanceCategory category;
  final DateTime dateTime;

  AllowanceItem({required this.id, required this.description, required this.amount, required this.category, required this.dateTime});
}