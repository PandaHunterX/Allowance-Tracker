import 'package:flutter/material.dart';
import 'package:productivity_app/styles/textstyle.dart';
import 'package:productivity_app/views/widgets/pie_graph.dart';
import 'package:productivity_app/views/widgets/profile_picture.dart';
import 'package:productivity_app/views/widgets/total_data.dart';
import 'package:productivity_app/views/widgets/user_allowance.dart';
import 'package:productivity_app/views/widgets/username.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width - 32,
              child: Column(
                children: [
                  Row(
                    children: [
                      ProfilePicture(size: 35,),
                      SizedBox(width: 16,),
                      Expanded(
                          child: Username(textAlign: TextAlign.start,))
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      TitleText(words: 'Remaining Allowance: ', size: 20, fontWeight: FontWeight.w600,),
                      SizedBox(width: 8,),
                      UserAllowance(),
                    ],
                  ),
                  Divider(height: 2, color: Colors.blue.shade900,)
                ],
              ),
            ),
            SizedBox(height: 20,),
            TotalData(),
            SizedBox(height: 20,),
            Divider(height: 2, color: Colors.blue.shade900,),
            SizedBox(height: 32,),
            PieGraph(),
          ],
        ),
      ),
    );
  }
}
