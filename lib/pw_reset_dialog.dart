import 'package:flutter/material.dart';
import 'package:tqwcoviddata/snackbar_helper.dart';

class PwReset extends StatelessWidget {
  const PwReset({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Reset Password'),
              content: const Text('Email to reset Password for:'),
              actions: <Widget>[
                TextFormField(),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          child: const Text('Reset Password now'),
        ),
      ],
    );
  }
}

Future<void> sendPasswordResetEmail() async {
  try {
    await _auth.sendPasswordResetEmail(email: _emailController.text);
  } catch (e) {
    ScaffoldSnackbar.of(context).show('Error: {}$e');
  }
}
