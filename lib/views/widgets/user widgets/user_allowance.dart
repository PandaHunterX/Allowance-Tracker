import 'package:flutter/material.dart';
import 'package:productivity_app/styles/text_style.dart';
import '../../../database/finance_db.dart';
import '../../../models/user model/user.dart';

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
        Text(
          user?.currency ?? '...',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 8,
        ),
        SecondaryText(words: user?.allowance.toString() ?? '...', size: 24, maxLines: 1)
      ],
    );
  }
}

//user?.currency ?? 'Loading',
//user?.allowance.toString() ?? 'Loading',
