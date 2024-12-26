import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 110,
      backgroundColor: Colors.blue.shade900,
      child: CircleAvatar(
        radius: 100,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SvgPicture.asset('assets/svg/man.svg')),
      ),
    );
  }
}