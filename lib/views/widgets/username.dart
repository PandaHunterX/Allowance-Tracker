import 'package:flutter/material.dart';

import '../../database/finance_db.dart';
import '../../models/user.dart';

class Username extends StatefulWidget {
  const Username({
    super.key,
  });

  @override
  State<Username> createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
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
    return Text(
      user?.username ?? 'Loading...',
      style: const TextStyle(fontSize: 32),
    );
  }
}