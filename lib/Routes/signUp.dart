import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class signupscreen extends StatefulWidget{
  final VoidCallback onClickedSignIn;
  const signupscreen({
    Key? key,
    required this.onClickedSignIn
  }) : super(key: key);
  @override
  _MyStatefulWidgetState1 createState() => _MyStatefulWidgetState1();
}
class _MyStatefulWidgetState1 extends State<signupscreen> {
  //user name field
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    //var onClickedSignIn;
    return  Padding(

        padding: const EdgeInsets.all(10),
        child: ListView(children: <Widget>[
          SizedBox(height:60),
          FlutterLogo(size:120),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Smart Work from Home',
              style:TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //SizedBox(height:100),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Welcome !',
                style: TextStyle(fontSize: 20),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              key: Key("username-field"),
              controller: userNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',

              ),
            ),

          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: TextField(
              key: Key("password-field"),
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
                child: const Text('Sign Up'),
                onPressed: () {
                  signUp(userNameController.text, passwordController.text)
                      .then((result) {
                    if (result == "success") {
                      Navigator.of(context).pushNamed("/userDashboard",arguments: "Dublin Bikes");
                    } else if (result == "network-request-failed") {
                      return showSimpleNotification(
                          Text(
                              'No Internet detected. Try again after connecting to internet',
                              style: TextStyle(color: Colors.white)),
                          background: Colors.red);
                    } else {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("Invalid credentials!"),
                            content: result == "unknown"
                                ? new Text("Empty username or password")
                                : new Text(result),
                            actions: <Widget>[
                              new TextButton(
                                child: new Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                }),

          ),
          SizedBox(height:10),
          // Container(
          //     height: 50,
          //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          //   child: ElevatedButton.icon(
          //
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.red,
          //       onPrimary: Colors.white,
          //       //minimumSize: Size(double.infinity,50),
          //     ),
          //     icon: FaIcon(FontAwesomeIcons.google,color:Colors.white),
          //     label: Text('Login with Google'),
          //     onPressed: (){
          //       final provider = Provider.of<GoogleSignInProvider>(context,listen:false);
          //       provider.googleLogin();
          //     },
          //   ),
          // ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: RichText(text: TextSpan(
              style:TextStyle(color:Colors.blue,fontSize: 15,),
              text: 'Already have an account?  ',
              children: [TextSpan(
                recognizer: TapGestureRecognizer() ..onTap=widget.onClickedSignIn,
                text: 'Log In',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary
                ),
              ),
              ],
            )
            ),
          ),

          // Container(
          //     alignment: Alignment.center,
          //     padding: const EdgeInsets.all(10),
          //     child: MouseRegion(
          //         cursor: SystemMouseCursors.click,
          //         child: new GestureDetector(
          //           onTap: () {
          //             Navigator.pushNamed(context, "/userDashboard",arguments: "Dublin Bikes");
          //           },
          //           child: new Text(
          //             "Continue as a guest",
          //             style: TextStyle(
          //                 fontSize: 16,
          //                 color: Colors.blue,
          //                 decoration: TextDecoration.underline),
          //           ),
          //         )))
        ]));
  }
  Future<String> signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }
}