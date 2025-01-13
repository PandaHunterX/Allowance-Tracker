import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/controllers/allowance%20controllers/new_allowance.dart';
import 'package:productivity_app/views/screens/settings.dart';
import 'package:productivity_app/styles/buttons.dart';
import 'package:productivity_app/views/widgets/allowance%20widgets/allowance_list.dart';

import '../widgets/user widgets/profile_picture.dart';
import '../widgets/user widgets/username.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ProfilePicture(
              key: UniqueKey(),
              size: MediaQuery.sizeOf(context).width <= 1280
                  ? MediaQuery.sizeOf(context).width * .2
                  : MediaQuery.sizeOf(context).width * .1,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .05,
            child: Username(
              key: UniqueKey(), textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => Settings(
                        refreshed: _refresh,
                      )));
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
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => NewAllowance(
                        onAllowanceAdded: _refresh,
                      )));
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width * .45,
              height: MediaQuery.sizeOf(context).height * .06,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(60)),
                  border: Border.all(width: 4, color: Colors.blue.shade600)),
              child: const Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.blue,
                    size: 36,
                  ),
                  Expanded(
                    child: AutoSizeText(
                      textAlign: TextAlign.center,
                      'Add Allowance',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          AllowancesList(
            key: UniqueKey(),
            refresh: _refresh,
          )
        ],
      ),
    );
  }
}
