import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:go_corona_admin/model/cities.dart';
import 'package:go_corona_admin/theme/theme.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:velocity_x/velocity_x.dart';
import '../methods/addPost.dart';

class AddPost extends StatefulWidget {
  final String email;
  AddPost(this.email);
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool loading = false;
  bool hover = false;
  List<String> resources = [];
  List<String> availableResources = [
    'Remdesivir',
    'Favipiravir',
    'Oxygen',
    'Ventilator',
    'Plasma',
    'Tocilizumab',
    'ICU',
    'Beds',
    'Food',
    'Ambulance',
    'Fabiflu',
    'Oxygen beds',
    'Concentrators',
    'Oxygen cans',
    'Oxygen cylinder',
    'Other'
  ];

  String location;
  TextEditingController description = TextEditingController();
  MediaInfo _image;

  Future getImage() async {
    MediaInfo imageFile = await ImagePickerWeb.getImageInfo;

    if (imageFile != null) {
      _image = imageFile;
      setState(() {});
      debugPrint(imageFile.fileName.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: "Add Post".text.white.make(),
          centerTitle: true,
          backgroundColor: AppColors().mainColor),
      body: VStack(
        [
          _image == null
              ? InkWell(
                  onTap: () {
                    getImage();
                  },
                  onHover: (val) {
                    setState(() {
                      hover = val;
                    });
                  },
                  child: VxBox(
                          child: VStack(
                    [
                      Icon(
                        Icons.camera_alt,
                        color: hover ? AppColors().mainColor : Colors.grey,
                        size: 50,
                      ),
                      SizedBox(height: 15),
                      AutoSizeText('Add Photo',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20))
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                    alignment: MainAxisAlignment.center,
                  ).p64())
                      .width(context.screenWidth / 1.5)
                      .height(context.screenHeight / 2)
                      .withDecoration(BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color:
                                  hover ? AppColors().mainColor : Colors.grey)))
                      .makeCentered(),
                )
              : InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: Image.memory(
                    _image.data,
                    width: context.screenWidth / 2,
                    fit: BoxFit.contain,
                  ).centered(),
                ),
          SizedBox(height: 15),
          Column(
            children: [
              "Location".text.bold.size(18).make().objectCenterLeft(),
              SizedBox(height: 10),
              SearchableDropdown.single(
                  displayClearIcon: false,
                  items: cities
                      .map((e) => DropdownMenuItem(
                            child: '$e'.text.make(),
                            value: e,
                          ))
                      .toList(),
                  value: location,
                  hint: 'Select a location'.text.make(),
                  onChanged: (val) {
                    location = val;
                    setState(() {});
                  })
/*               DropdownButtonFormField(
                value: location,
                hint: 'Select a locaton'.text.make(),
                onChanged: (val){
                  location = val;  
                  setState(() {});
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide()
                  )
                ),
                items: cities.map((e) => DropdownMenuItem(child: '$e'.text.make(),value: e,)).toList()) */
            ],
          ).w64(context),
          SizedBox(height: 15),
          Column(
            children: [
              "Description".text.bold.size(18).make().objectCenterLeft(),
              SizedBox(height: 10),
              TextFormField(
                controller: description,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText:
                        'Tell us more information. Phone number, contact details & etc.',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 0.5),
                        borderRadius: BorderRadius.circular(5))),
              ),
            ],
          ).w64(context),
          SizedBox(height: 15),
          Column(
            children: [
              "Resource available".text.bold.size(18).make().objectCenterLeft(),
              SizedBox(height: 10),
              ChipsChoice<String>.multiple(
                wrapped: true,
                spacing: 8,
                runSpacing: 8,
                wrapCrossAlignment: WrapCrossAlignment.start,
                choiceActiveStyle: C2ChoiceStyle(color: AppColors().mainColor),
                value: resources,
                choiceItems: C2Choice.listFrom<String, String>(
                  source: availableResources,
                  value: (i, v) => v,
                  label: (i, v) => v,
                ),
                onChanged: (val) {
                  setState(() => resources = val);
                  print(resources);
                },
              ),
            ],
          ).w64(context),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async {
              if (location.trim().length == 0) {
                context.showToast(
                    msg: 'location can\'t be empty',
                    bgColor: Colors.red,
                    textColor: Colors.white);
              } else if (_image == null &&
                  description.text.trim().length == 0) {
                context.showToast(
                    msg: 'both images and description cant be empty',
                    bgColor: Colors.red,
                    textColor: Colors.white);
              } else if (resources.isEmpty) {
                context.showToast(
                    msg: 'Select atleast one resource.',
                    bgColor: Colors.red,
                    textColor: Colors.white);
              } else {
                loading = true;
                setState(() {});
                bool result = await addPost(
                  location: location.toLowerCase(),
                  description: description.text,
                  resources: resources,
                  image: _image,
                  email: widget.email,
                );
                if (result) {
                  context.showToast(
                      msg: 'Post added',
                      bgColor: Colors.green,
                      textColor: Colors.white);
                  loading = false;
                  setState(() {});
                  Navigator.pop(context);
                }
              }
            },
            child: Row(
              children: [
                "Add Post".text.size(16).make().px4(),
                loading
                    ? CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ).px2()
                    : Container().w0(context).h0(context)
              ],
              mainAxisSize: MainAxisSize.min,
            ).p8(),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppColors().mainColor)),
          )
        ],
        alignment: MainAxisAlignment.center,
        crossAlignment: CrossAxisAlignment.center,
      ).py32().scrollVertical(),
    );
  }
}
