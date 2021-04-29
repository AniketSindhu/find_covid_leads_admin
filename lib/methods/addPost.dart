import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<bool> addPost(
    {String location,
    List<String> resources,
    String description,
    MediaInfo image,
    BuildContext context,
    String email}) async {
  try {
    if (image == null) {
      await FirebaseFirestore.instance.collection('posts').add({
        'description': description,
        'location': location.toLowerCase(),
        'resources': resources,
        'image': null,
        'postedBy': email.toLowerCase(),
        'time': DateTime.now(),
        'upvotes': 0
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('locations')
            .doc('locations')
            .update({
          'loc': FieldValue.arrayUnion([location.toLowerCase()])
        });
        return true;
      }).onError((error, stackTrace) {
        context.showToast(
            msg: error.message, bgColor: Colors.red, textColor: Colors.white);
        return false;
      });
      return true;
    } else {
      String mimeType = mime(basename(image.fileName));
      final String extension = extensionFromMime(mimeType);
      var metadata = SettableMetadata(
        contentType: mimeType,
      );
      final uploadTask = await firebase_storage.FirebaseStorage.instance
          .ref('images/${image.fileName}')
          .putData(image.data, metadata);
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('posts').add({
        'description': description,
        'location': location.toLowerCase(),
        'resources': resources,
        'image': imageUrl,
        'postedBy': email.toLowerCase(),
        'time': DateTime.now(),
        'upvotes': 0
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('locations')
            .doc('locations')
            .update({
          'loc': FieldValue.arrayUnion([location.toLowerCase()])
        });
        return true;
      }).onError((error, stackTrace) {
        context.showToast(
            msg: error.message, bgColor: Colors.red, textColor: Colors.white);
        return false;
      });
      return true;
    }
  } on FirebaseException catch (e) {
    print(e.message);
    context.showToast(
        msg: e.message, bgColor: Colors.red, textColor: Colors.white);
    return false;
  }
}
