import 'package:flutter/material.dart';
import 'package:go_corona_admin/methods/addPost.dart';
import 'package:velocity_x/velocity_x.dart';

class Homepage extends StatefulWidget {
  String email;
  Homepage({this.email});
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Vx.yellow500,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Center(
        child: widget.email.text.yellow500.bold.size(18).makeCentered(),
      ),
    );
  }
}
