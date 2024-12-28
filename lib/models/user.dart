
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class User {
  final String id;
  final String username;
  final double allowance;

  User({required this.username, required this.allowance}) : id = uuid.v4();
}
