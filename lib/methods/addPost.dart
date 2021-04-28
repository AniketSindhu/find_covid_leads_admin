import 'package:auto_size_text/auto_size_text.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
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
  ];
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: "Add Post".text.white.make(),
          centerTitle: true,
          backgroundColor: Colors.redAccent),
      body: VStack(
        [
          InkWell(
            onTap: () {},
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
                  color: hover ? Colors.redAccent : Colors.grey,
                  size: 50,
                ),
                SizedBox(height: 15),
                AutoSizeText('Add Photo',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20))
              ],
              crossAlignment: CrossAxisAlignment.center,
              alignment: MainAxisAlignment.center,
            ).p64())
                .width(context.screenWidth / 1.5)
                .height(context.screenHeight / 2)
                .withDecoration(BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: hover ? Colors.redAccent : Colors.grey)))
                .makeCentered(),
          ),
          SizedBox(height: 15),
          Column(
            children: [
              "Location".text.bold.size(18).make().objectCenterLeft(),
              SizedBox(height: 10),
              TextFormField(
                controller: location,
                decoration: InputDecoration(
                    labelText: 'Enter a Location',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 0.5),
                        borderRadius: BorderRadius.circular(5))),
              ),
            ],
          ).w56(context),
          SizedBox(height: 15),
          Column(
            children: [
              "Description".text.bold.size(18).make().objectCenterLeft(),
              SizedBox(height: 10),
              TextFormField(
                controller: location,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText:
                        'Tell us more information. Phone number, contact details & etc.',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 0.5),
                        borderRadius: BorderRadius.circular(5))),
              ),
            ],
          ).w56(context),
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
                choiceActiveStyle: C2ChoiceStyle(color: Colors.redAccent),
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
          ).w56(context),
          ElevatedButton(onPressed: () {}, child: "Add Post".text.make())
        ],
        alignment: MainAxisAlignment.center,
        crossAlignment: CrossAxisAlignment.center,
      ).py32().scrollVertical(),
    );
  }
}
