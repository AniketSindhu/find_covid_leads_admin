import 'package:flutter/material.dart';
import 'package:go_corona_admin/pages/homepage.dart';
import 'package:go_corona_admin/methods/loginMethod.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: VStack(
          [
            HStack(
              [
                "Find ".text.bold.color(Colors.redAccent).size(25).make(),
                "Covid".text.black.bold.size(25).make(),
                " leads!".text.bold.color(Colors.redAccent).size(25).make(),
              ],
              alignment: MainAxisAlignment.center,
              axisSize: MainAxisSize.max,
            ),
            "(Admin Panel)".text.size(20).make(),
            SizedBox(height: 40),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.5),
                      borderRadius: BorderRadius.circular(5))),
            ).w56(context),
            SizedBox(height: 20),
            TextFormField(
              controller: pass,
              decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.5),
                      borderRadius: BorderRadius.circular(5))),
            ).w56(context),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (email.text.trim().length == 0) {
                  context.showToast(
                      msg: 'Email cannot be empty',
                      bgColor: Colors.red,
                      textColor: Colors.white);
                } else if (pass.text.trim().length == 0) {
                  context.showToast(
                      msg: 'Invalid password',
                      bgColor: Colors.red,
                      textColor: Colors.white);
                } else {
                  loading = true;
                  setState(() {});
                  final result =
                      await login(email: email.text, pass: pass.text);
                  if (result) {
                    context.showToast(
                        msg: 'Success!',
                        bgColor: Colors.green,
                        textColor: Colors.white);

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Homepage(
                                  email: email.text,
                                )));
                  } else {
                    context.showToast(
                        msg: 'Failed, Check your credentials!',
                        bgColor: Colors.red,
                        textColor: Colors.white);
                  }
                  loading = false;
                  setState(() {});
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  "Login".text.white.bold.size(16).makeCentered().px4(),
                  loading
                      ? CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ).px2()
                      : Container().w0(context).h0(context)
                ],
              ).p12(),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
            )
          ],
          alignment: MainAxisAlignment.center,
          axisSize: MainAxisSize.max,
          crossAlignment: CrossAxisAlignment.center,
        ));
  }
}
