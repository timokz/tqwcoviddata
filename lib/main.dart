import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:tqwcoviddata/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TqwDataApp()); //ProviderScope(child: App()));
}
/// The entry point of the application.
///
/// Returns a [MaterialApp].
class TqwDataApp extends StatefulWidget {
  const TqwDataApp({Key? key}) : super(key: key);

  @override
  _TqwDataAppState createState() => _TqwDataAppState();
}
class _TqwDataAppState extends State<TqwDataApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SnackBar(
              content: Text(
                  'Database Connection failed to establish. Please try again.',
              ),);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              title: 'tqwcoviddata',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Colors.black,
                backgroundColor: const Color(0xffffffff),
                fontFamily: 'Roboto',
              ),
              home: const HomeScreen(),);
        }
        return const CircularProgressIndicator(
          backgroundColor: Color(0x0000000c),
          value: 12,
        );
      },
    );
  }
}
