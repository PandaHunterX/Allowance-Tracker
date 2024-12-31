import 'package:flutter/material.dart';
import '../../database/finance_db.dart';
import '../../models/user.dart';

class UserAllowance extends StatefulWidget {
  const UserAllowance({super.key});

  @override
  State<UserAllowance> createState() => _UserAllowanceState();
}

class _UserAllowanceState extends State<UserAllowance> {
  User? user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final db = FinanceDB();
    final fetchUser = await db.fetchUser();
    setState(() {
      user = fetchUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(user?.currency ?? 'Loading'),
        const SizedBox(width: 8,),
        Text(user?.allowance.toString() ?? 'Loading'),
      ],
    );
  }
}
