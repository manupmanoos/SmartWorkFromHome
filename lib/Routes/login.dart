import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';


class loginscreen extends StatefulWidget {
  //final VoidCallback onClickedSignUp;
  const loginscreen({
    Key? key,
    //required this.onClickedSignUp
  }) : super(key: key);
    @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<loginscreen> {
  //user name field
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        resizeToAvoidBottomInset: false,
        body:
      Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(children: <Widget>[
            SizedBox(height:60),
            Container(
              height: 210.0,
              width: 210.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/wfh_image.png'),
                  fit: BoxFit.fitHeight,
                ),
                shape: BoxShape.circle,
              ),
            ),
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
                ),
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
                    child: const Text('Sign In'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                    ),
                    onPressed: () {
                      signIn(userNameController.text, passwordController.text)
                          .then((result) {
                        if (result == "success") {
                          Navigator.of(context).pushNamed("/userDashboard");
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
    //     Container(
    //           alignment: Alignment.center,
    //           padding: const EdgeInsets.all(10),
    //         child: RichText(text: TextSpan(
    //           style:TextStyle(color:Colors.blue,fontSize: 15,),
    //             text: 'No account?  ',
    //             children: [TextSpan(
    //             recognizer: TapGestureRecognizer() ..onTap=widget.onClickedSignUp,
    //             text: 'Sign Up',
    //             style: TextStyle(
    //             decoration: TextDecoration.underline,
    //             color: Theme.of(context).colorScheme.secondary
    //         ),
    // ),
    //           ],
    //         )
    //         ),
    //     ),

            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/userDashboard");
                      },
                      // child: new Text(
                      //   "Continue as a guest",
                      //   style: TextStyle(
                      //       fontSize: 16,
                      //       color: Colors.blue,
                      //       decoration: TextDecoration.underline),
                      // ),
                    )))

          ])));
  }

  /*
  * signIn method is used to authenticate credentials with firebase
  *
  * @param String email
  * @param String password
  * @return Future<String> (success or auth message)
  * */
  Future<String> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

}
