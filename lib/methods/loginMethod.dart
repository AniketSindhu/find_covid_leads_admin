import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<bool> login({String email, String pass}) async {
  email = email.toLowerCase();
  final x = await FirebaseFirestore.instance
      .collection('mods')
      .where('email', isEqualTo: email)
      .get();

  if (x.docs.isEmpty) {
    return false;
  } else {
    return x.docs[0].data()['pass'] == pass;
  }
}
