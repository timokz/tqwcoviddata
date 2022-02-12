import 'package:flutter/material.dart';
import 'package:tqwcoviddata/email_form.dart';
import 'package:url_launcher/url_launcher.dart';

/// Provides Appbar and entry to EmailPasswordForm
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    const _url = 'https://tqw.at';
    void _launchURL() async => await canLaunch(_url)
        ? await launch(_url)
        : throw 'Could not connect to $_url';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        title: TextButton(
            style: const ButtonStyle(),
            onPressed: _launchURL,
            child: const Text(
              "TQW Home",
              style: TextStyle(
                decorationColor: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto",
                //    fontStyle: FontStyle.italic,
              ),
            )),
        backgroundColor: Colors.black,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            padding: const EdgeInsets.all(8),
            children: const <Widget>[
              EmailPasswordForm(),
            ],
          );
        },
      ),
    );
  }
}