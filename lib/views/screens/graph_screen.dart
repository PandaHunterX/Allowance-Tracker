import 'package:flutter/cupertino.dart';
import 'package:productivity_app/views/widgets/pie_graph.dart';
import 'package:productivity_app/views/widgets/profile_picture.dart';
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
                      Username()
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Text('Your Allowance: '),
                      UserAllowance(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32,),
            PieGraph(),
          ],
        ),
      ),
    );
  }
}
