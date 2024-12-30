import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/profile_pictures_list.dart';

class ChangeProfile extends StatefulWidget {
  final VoidCallback changed_profile;
  final VoidCallback refreshed;

  const ChangeProfile({
    super.key, required this.changed_profile, required this.refreshed,
  });

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  var save_svg = "";
  String selected_profile = "";

  void _save_profile() async {
    final db = FinanceDB();
    if (save_svg == ""){
      return;
    }
    else {
      await db.updateAvatar(save_svg);
      widget.changed_profile();
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
            children: profile_pics.map((profile) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selected_profile = profile.svg;
                  });
                  save_svg = profile.svg;
                },
                child: CircleAvatar(
                  backgroundColor: selected_profile == profile.svg ? Colors.blue.shade900 : Colors.white,
                  radius: 60,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 60,
                    child: SvgPicture.asset(profile.svg, width: 80,),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            _save_profile();
            Navigator.of(context).pop(); // Dismiss alert dialog
          },
        ),
      ],
    );
  }
}
