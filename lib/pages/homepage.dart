import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_corona_admin/model/post.dart';
import 'package:go_corona_admin/pages/addPost.dart';
import 'package:go_corona_admin/widgets/postWidget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:timeago/timeago.dart' as timeago;

class Homepage extends StatefulWidget {
  String email;
  Homepage({this.email = 'sindhuaniket@gmail.com'});
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: "Your posts".text.make(),
          centerTitle: true,
        ),
        backgroundColor: Color(0xffDAE0E6),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddPost(widget.email)));
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('postedBy', isEqualTo: widget.email.toLowerCase())
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator().centered();
            } else if (!snapshot.hasData || snapshot.hasError) {
              print(snapshot.data.docs[0].data());
              return "Something Went wrong".text.red500.size(20).makeCentered();
            } else {
              if (snapshot.data.docs.length == 0) {
                return "No post yet".text.red500.size(20).makeCentered();
              } else {
                return Column(
                  children: [
                    20.heightBox,
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          Post post = Post.fromDocument(
                              snapshot.data.docs[index].data());
                          return VxResponsive(
                            xlarge: postWidget(post)
                                .width(context.screenWidth * 0.75)
                                .withDecoration(BoxDecoration(
                                    border: Border.all(width: 0.3),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)))
                                .makeCentered()
                                .py12(),
                            large: postWidget(post)
                                .width(context.screenWidth * 0.75)
                                .withDecoration(BoxDecoration(
                                    border: Border.all(width: 0.3),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)))
                                .makeCentered()
                                .py12(),
                            medium: postWidget(post)
                                .width(context.screenWidth * 0.8)
                                .withDecoration(BoxDecoration(
                                    border: Border.all(width: 0.3),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)))
                                .makeCentered()
                                .py12(),
                            small: postWidget(post)
                                .width(context.screenWidth * 0.9)
                                .withDecoration(BoxDecoration(
                                    border: Border.all(width: 0.3),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)))
                                .makeCentered()
                                .py12(),
                            xsmall: postWidget(post)
                                .width(context.screenWidth * 0.9)
                                .withDecoration(BoxDecoration(
                                    border: Border.all(width: 0.3),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)))
                                .makeCentered()
                                .py12(),
                            fallback: postWidget(post)
                                .width(context.screenWidth * 0.75)
                                .withDecoration(BoxDecoration(
                                    border: Border.all(width: 0.3),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)))
                                .makeCentered()
                                .py12(),
                          );
                        }).centered(),
                  ],
                ).scrollVertical();
              }
            }
          },
        ));
  }
}
