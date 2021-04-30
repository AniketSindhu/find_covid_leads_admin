import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_corona_admin/pages/homepage.dart';
import 'package:go_corona_admin/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String email;
  bool done = false;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  getLoginState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    email = preferences.getString('email');
    done = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getLoginState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Go corona',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: done
            ? FutureBuilder(
                future: _initialization,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Scaffold(
                        body: Center(
                            child: Text(
                      'Error',
                      style: TextStyle(color: Colors.red),
                    )));
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return email == null || email == ''
                        ? LoginPage()
                        : Homepage(email: email);
                  }
                  return Scaffold(
                      body: Center(
                    child: CircularProgressIndicator(),
                  ));
                })
            : Scaffold(
                body: Center(
                child: CircularProgressIndicator(),
              )));
  }
}
