import 'package:go_corona_admin/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> deletePost(Post post) async {
  final x = await FirebaseFirestore.instance
      .collection('posts')
      .where('time', isEqualTo: post.time)
      .get();
  await FirebaseFirestore.instance
      .collection('posts')
      .doc(x.docs[0].id)
      .delete();

  return true;
}
