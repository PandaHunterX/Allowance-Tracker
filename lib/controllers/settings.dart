import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:productivity_app/views/widgets/profile_picture.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                children: [
                  const ProfilePicture(),
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
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Name: Username",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                width: 16,
              ),
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
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Divider(
            height: 4,
            thickness: 4,
            color: Colors.blue.shade500,
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
