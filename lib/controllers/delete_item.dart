import 'package:flutter/material.dart';
import '../styles/textstyle.dart';

class DeleteItem extends StatelessWidget {
  final dynamic item;
  final VoidCallback delete;
  final BuildContext context;

  const DeleteItem({
    super.key,
    required this.item,
    required this.delete,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'DELETE ITEM',
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width - 200,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/delete-item.png',
                width: 250,
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                  child: SecondaryText(
                    words: 'Are you sure you want to delete $item',
                    size: 24,
                    maxLines: 2,
                  )),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss alert dialog
          },
        ),
        ElevatedButton(onPressed: delete, child: Text('Yes'))
      ],
    );
  }
}