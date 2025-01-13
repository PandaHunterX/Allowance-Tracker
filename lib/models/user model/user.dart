import 'package:uuid/uuid.dart';

const uuid = Uuid();

class User {
  final String id;
  final String username;
  final String avatar;
  final String currency;
  final double allowance;

  User({required this.username,required this.avatar, required this.currency, required this.allowance}) : id = uuid.v4();
}
