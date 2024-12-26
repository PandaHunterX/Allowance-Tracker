import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:productivity_app/controllers/settings.dart';
import 'package:productivity_app/styles/buttons.dart';

import '../widgets/profile_picture.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: ProfilePicture(),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Username',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => const Settings()));
            },
            child: const CustomizeButton(
              text: 'Settings',
              icon: Icons.settings,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(
            height: 2,
            thickness: 2,
            color: Colors.blue,
          ),
          const SizedBox(
            height: 24,
          ),
          const Text('Your Allowance: '),

        ],
      ),
    );
  }
}
