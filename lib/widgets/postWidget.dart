import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_corona_admin/model/post.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:timeago/timeago.dart' as timeago;

VxBox postWidget(Post post) {
  return VxBox(
          child: VStack(
    [
      Row(
        children: [
          post.postedBy.text.bold.make(),
          timeago.format(post.time).text.bold.make()
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
      ),
      SizedBox(height: 10),
      post.image == null
          ? Container().h(0).w(0)
          : CachedNetworkImage(
              imageUrl: post.image,
              placeholder: (context, url) => VxBox()
                  .width(double.infinity)
                  .roundedSM
                  .height(context.screenHeight / 1.8)
                  .gray500
                  .make()
                  .shimmer(),
              errorWidget: (context, url, error) {
                print(error);
                return Icon(Icons.error);
              },
            ).centered(),
      SizedBox(height: 5),
      "Location: ${post.location}".text.bold.size(16).make().objectCenterLeft(),
      SizedBox(height: 5),
      Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 10,
        spacing: 10,
        children: post.resources
            .map((e) => Chip(
                  label: '$e'.toString().text.white.make(),
                  backgroundColor: Colors.redAccent,
                ))
            .toList(),
      ),
      post.description != null || post.description.trim().length != 0
          ? SizedBox(height: 10)
          : Container(),
      post.description != null || post.description.trim().length != 0
          ? "${post.description}".text.make().objectCenterLeft()
          : Container()
    ],
    crossAlignment: CrossAxisAlignment.center,
  ).p12())
      .shadow;
}
