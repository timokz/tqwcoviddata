import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tqwcoviddata/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController pwCon = TextEditingController();

  @override
  void dispose() {
    pwCon.dispose();
    super.dispose();
  }

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
              "home", //  Text("TQW Covid Form",
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
              LoginPage(),
            ],
          );
        },
      ),);
  }
}