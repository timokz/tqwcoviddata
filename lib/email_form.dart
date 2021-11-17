import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tqwcoviddata/get_guest_data.dart';
import 'snackbar_helper.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class EmailPasswordForm extends StatefulWidget {
  const EmailPasswordForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
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
              TextFormField(
                controller: _emailController,
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
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (String? value) {
                  if (value!.isEmpty) return 'Passwort leer oder falsch';
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
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: const Text('Anmelden'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _signInWithEmailAndPassword();
                      navOnAuth();
                    }
                  },
                ),
              ),
            ],
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

  // Example code of how to sign in with email and password.
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

  navOnAuth() {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const GetGuestData()));
    }
  }
}
/*
class _EmailLinkSignInSection extends StatefulWidget {
  const _EmailLinkSignInSection({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmailLinkSignInSectionState();
}

class _EmailLinkSignInSectionState extends State<_EmailLinkSignInSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Form(
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
                  'Test sign in with email and link',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (String? value) {
                  if (value!.isEmpty) return 'Please enter your email.';
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: ElevatedButton(
                  // icon: Icons.insert_link,
                  child: const Text("Anmelden"),
                  //    backgroundColor: Colors.blueGrey[700]!,
                  onPressed: () async {
                    await _signInWithEmailAndLink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndLink() async {
    try {
      _email = _emailController.text;

      await _auth.sendSignInLinkToEmail(
        email: _email,
        actionCodeSettings: ActionCodeSettings(
          url:
              'https://react-native-firebase-testing.firebaseapp.com/emailSignin',
          handleCodeInApp: true,
          iOSBundleId: 'io.flutter.plugins.firebaseAuthExample',
          androidPackageName: 'io.flutter.plugins.firebaseauthexample',
        ),
      );

      ScaffoldSnackbar.of(context).show('An email has been sent to $_email');
    } catch (e) {
      print(e);
      ScaffoldSnackbar.of(context).show('Sending email failed');
    }
  }
} */