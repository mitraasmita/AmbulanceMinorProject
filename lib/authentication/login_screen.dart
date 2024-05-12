import 'package:driver_app/authentication/signup_screen.dart';
import 'package:driver_app/methods/common_methods.dart';
import 'package:driver_app/pages/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
 import 'package:driver_app/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget
{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable()
  {
  //   cMethods.checkConnectivity(context);
  //
    signInFormValidation();
  }

  signInFormValidation()
  {
    if(!emailTextEditingController.text.contains('@'))
    {
      cMethods.displaySnackBar("Please enter a valid Email ID", context);
    }
    else if(passwordTextEditingController.text.trim().length < 5)
    {
      cMethods.displaySnackBar("Your Password must atleast 6 or more characters.", context);
    }
    else
    {
      //signin the user
      signInUser();
    }
  }

  signInUser() async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Logging in..."),
    );

    final User? userFirebase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((errorMsg)
        {
          Navigator.pop(context);
          cMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;

    if(!context.mounted) return;
    Navigator.pop(context);

    if(userFirebase != null)
      {
        DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("drivers").child(userFirebase!.uid);
        usersRef.once().then((snap)
        {
          if(snap.snapshot.value != null) //this means that the driver's record exist
          {
            if ((snap.snapshot.value as Map)["blockStatus"] =="no")
            {
              //userName = (snap.snapshot.value as Map)["name"];
              Navigator.push(context, MaterialPageRoute(builder: (c)=> Dashboard()));
            }
            else
            {
              FirebaseAuth.instance.signOut();
              cMethods.displaySnackBar("You are blocked. Please contact the admin.",context);
            }
          }
          else
            {
              FirebaseAuth.instance.signOut();
              cMethods.displaySnackBar("Your record does not exist as an driver.",context);
            }
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [

                const SizedBox(
                  height: 60,
                ),

                Image.asset(
                    "assests/images/ambulance.png",
                     width: 220,
                ),

                const SizedBox(
                  height: 40,
                ),

                const Text(
                  "Login as a Driver",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //text fields + Login button
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      //Text Field for Email
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Driver Email",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "Enter your registered email",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 22,),

                      //Text Field for Password
                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "Enter your Password",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 35,),

                      ElevatedButton(
                        onPressed: ()
                        {
                          checkIfNetworkIsAvailable();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12)
                        ),
                        child: const Text(
                            "Login"
                        ),
                      )

                    ],
                  ),
                ),

                const SizedBox(height: 10,),

                //text button - Already have an account Login Here
                TextButton(
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> SignUpScreen()));
                  },
                  child: const Text(
                    "Don't have an account? Sign In Here",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )

              ],
            ),
          ),
        )
    );
  }
}
