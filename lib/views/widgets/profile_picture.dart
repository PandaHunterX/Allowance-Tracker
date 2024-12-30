import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/user.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
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
    return CircleAvatar(
      radius: 110,
      backgroundColor: Colors.blue.shade900,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 100,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: user != null ? SvgPicture.asset(user!.avatar) : const CircularProgressIndicator()),
      ),
    );
  }
}