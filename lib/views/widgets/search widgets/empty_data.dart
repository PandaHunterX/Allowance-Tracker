import 'package:flutter/cupertino.dart';
import 'package:productivity_app/styles/text_style.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/empty-list.png',
          width: MediaQuery.sizeOf(context).width - 200,
        ),
        TitleText(
          words: 'No data available',
          size: 24,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
