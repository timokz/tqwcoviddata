import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tqwcoviddata/get_guest_data.dart';
import 'snackbar_helper.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

///
/// Builds the email and pw forms required to register with firebase
///
/// Uses contents of TextFormFields to register with firebaseAuth
/// Additional functionality to reset PW and remember TextFormFields
class EmailPasswordForm extends StatefulWidget {
  const EmailPasswordForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  ///
  /// _formKey [GlobalKey<FormState>] global key
  /// _emaillController [TextFormfield] for email value
  /// _emaillController [TextFormfield] for password value
  ///
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Contact-Tracing Authentifizierung',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AutofillGroup(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        autofillHints: const [AutofillHints.email],
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (String? value) {
                          if (value!.isEmpty) return 'Email leer oder falsch';
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        autofillHints: const [AutofillHints.password],
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        validator: (String? value) {
                          if (value!.isEmpty)
                            return 'Passwort leer oder falsch';
                          return null;
                        },
                        obscureText: true,
                        onFieldSubmitted: (value) async {
                          if (_formKey.currentState!.validate()) {
                            await _signInWithEmailAndPassword();
                            navOnAuth();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        }),
                    const Text(
                      "Remember Me",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      child: const Text('Anmelden'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _signInWithEmailAndPassword();
                          navOnAuth();
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user!;
      ScaffoldSnackbar.of(context).show('${user.email} authentifiziert');
    } catch (e) {
      ScaffoldSnackbar.of(context).show('Auth nicht erfolgreich');
    }
  }

  Future<void> sendPasswordResetEmail() async {
    try {
      _auth.sendPasswordResetEmail(email: _emailController.text);
    } catch (e) {
      ScaffoldSnackbar.of(context).show('Error: {}' + e.toString());
    }
  }

  confirmReset(String code, String newPassword) {
    _auth.confirmPasswordReset(code: code, newPassword: newPassword);
  }

  navOnAuth() {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const GetGuestData()));
    }
  }
}
