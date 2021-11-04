import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'get_guest_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      body: Padding(
          padding: const EdgeInsets.all(32.0),
          //      padding: const EdgeInsets.fromLTRB(32.0,32.0,32.0,0),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _launchURL, // handle your image tap here
                      child: const Image(
                        image: AssetImage('graphics/tqwlogo.jfif'),
                      ))),
              TextField(
                  controller: pwCon,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  )),
              ElevatedButton(
                  onPressed: () => {
                        if (pwCon.text.toString() == "Tanz5455")
                          {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return GetGuestData();
                            }))
                          }
                        else
                          const ScaffoldMessenger(
                              child:
                                  SnackBar(content: Text("Falsches Passwort")))
                      },
                  child: const Text("Check")), //    Center(child:),
            ],
          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}