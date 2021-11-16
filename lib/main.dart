import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tqwcoviddata/get_guest_data.dart';
import 'dart:async';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const App()); //ProviderScope(child: App()));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("made it to snapshot error ");

          return const SnackBar(
              content: Text(
                  "Database Connection failed to establish. Please try again."));
        }
// Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'tqwcoviddata',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.black,
              backgroundColor: const Color(0xffffffff),
              fontFamily: 'Roboto',
            ),
           // home: const GetGuestData());
               home: const HomeScreen());
        }
// Otherwise, show something whilst waiting for initialization to complete
        return const CircularProgressIndicator(
          backgroundColor: Color(0x0000000c),
          value: 12,
        );
      },
    );
  }
}