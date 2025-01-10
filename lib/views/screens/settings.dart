import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:productivity_app/views/widgets/currency_dropdown.dart';
import 'package:productivity_app/views/widgets/profile_picture.dart';
import 'package:productivity_app/views/widgets/username.dart';
import 'package:productivity_app/controllers/username_form.dart';

import '../../controllers/changed_profile.dart';

class Settings extends StatefulWidget {
  final VoidCallback refreshed;

  const Settings({super.key, required this.refreshed});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                children: [
                  ProfilePicture(key: UniqueKey(), size: 100,),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.shade200,
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/svg/camera.svg',
                            width: 40,
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return ChangeProfile(
                              changed_profile: widget.refreshed,
                              refreshed: refresh,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 32,
                  child: Username(key: UniqueKey())),
              const SizedBox(width: 16),
              InkWell(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/svg/pencil.svg',
                      width: 30,
                    ),
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => UsernameForm(
                      onUsernameChanged: widget.refreshed,
                      refreshed: refresh,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          Divider(
            height: 4,
            thickness: 4,
            color: Colors.blue.shade500,
          ),
          const SizedBox(height: 32),
          CurrencyDropdown(onCurrencyChanged: widget.refreshed,),
        ],
      ),
    );
  }
}