import 'package:uuid/uuid.dart';
import 'category.dart';

const uuid = Uuid();

class AllowanceItem {
  final String id;
  final String name;
  final double allowance;
  final AllowanceCategory category;
  final DateTime dateTime;

  AllowanceItem({ required this.name, required this.allowance, required this.category, required this.dateTime}): id = uuid.v4();
}