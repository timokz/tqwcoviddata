import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tqwcoviddata/snackbar_helper.dart';

class PwReset extends StatelessWidget {
  PwReset({Key? key}) : super(key: key);
  final _emailController = TextEditingController();

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
                TextFormField(
                  controller: _emailController,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (String? value) {
                    if (value!.isEmpty) return 'Email leer';
                    return null;
                  },
                ),
                TextButton(
                  onPressed: () => {
                    Navigator.pop(context, 'Cancel'),
                    Navigator.pop(context, 'PWReset')
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await sendPasswordResetEmail(context);
                    Navigator.pop(context, 'OK'); //should be fine since stateless
                    Navigator.pop(context, 'PWReset');
                  },
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

  Future<void> sendPasswordResetEmail(BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
    } catch (e) {
      ScaffoldSnackbar.of(context).show('Error: {} $e');
    }
  }

}
