import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../database/finance_db.dart';
import '../../../models/user model/user.dart';

class Username extends StatefulWidget {
  final TextAlign textAlign;
  const Username({
    super.key, required this.textAlign,
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
    return AutoSizeText(
      textAlign: widget.textAlign,
      user?.username ?? 'Loading...',
      maxLines: 1,
      style: const TextStyle(
          fontSize: 32,
        fontFamily: 'Signika Negative',
      ),
    );
  }
}