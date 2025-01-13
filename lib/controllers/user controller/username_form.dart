import 'package:flutter/material.dart';
import 'package:productivity_app/database/finance_db.dart';

class UsernameForm extends StatefulWidget {
  final VoidCallback onUsernameChanged;
  final VoidCallback refreshed;

  const UsernameForm(
      {super.key, required this.onUsernameChanged, required this.refreshed});

  @override
  State<UsernameForm> createState() => _UsernameFormState();
}

class _UsernameFormState extends State<UsernameForm> {
  final _formKey = GlobalKey<FormState>();
  var _enteredUsername = '';
  final TextEditingController usernameController = TextEditingController();

  void _submitUsername() async {
    final db = FinanceDB();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await db.updateUsername(_enteredUsername);
      widget.onUsernameChanged();
      widget.refreshed();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Username'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/change-username.png',
              width: MediaQuery.sizeOf(context).width * .5,
              height: MediaQuery.viewInsetsOf(context).bottom > 0
                  ? MediaQuery.sizeOf(context).height * .15
                  : MediaQuery.sizeOf(context).height * .25,
            ),
            TextFormField(
              controller: usernameController,
              maxLength: 20,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 30) {
                  return 'Please enter a valid username';
                }
                return null;
              },
              onSaved: (value) {
                _enteredUsername = value!;
              },
              decoration: const InputDecoration(
                  label: Text('Username'), hintText: 'Enter your Name'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Colors.blue[50],
            ),
          ),
          onPressed: _submitUsername,
          child: const Text(
            'SAVE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
