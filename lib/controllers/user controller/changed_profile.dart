import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/user%20model/profile_pictures_list.dart';

class ChangeProfile extends StatefulWidget {
  final VoidCallback changedProfile;
  final VoidCallback refreshed;

  const ChangeProfile({
    super.key,
    required this.changedProfile,
    required this.refreshed,
  });

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  var saveSvg = "";
  String selectedProfile = "";

  void _saveProfile() async {
    final db = FinanceDB();
    if (saveSvg == "") {
      return;
    } else {
      await db.updateAvatar(saveSvg);
      widget.changedProfile();
      widget.refreshed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Profile Picture'),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).width * .6,
        child: SingleChildScrollView(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: profilePics.map((profile) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedProfile = profile.svg;
                  });
                  saveSvg = profile.svg;
                },
                child: CircleAvatar(
                  backgroundColor: selectedProfile == profile.svg
                      ? Colors.blue.shade900
                      : Colors.white,
                  radius: 60,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: SvgPicture.asset(
                      profile.svg,
                      width: 80,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue[50])),
          child: const Text(
            'SAVE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          onPressed: () {
            _saveProfile();
            Navigator.of(context).pop(); // Dismiss alert dialog
          },
        ),
      ],
    );
  }
}
