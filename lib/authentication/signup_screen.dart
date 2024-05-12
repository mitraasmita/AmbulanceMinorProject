import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:third_project/authentication/login_screen.dart';
import 'package:third_project/methods/common_methods.dart';
import 'package:third_project/pages/home_page.dart';
import 'package:third_project/widgets/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class  SignUpScreen extends StatefulWidget
{
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
{
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController phonenumberTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();


  checkIfNetworkIsAvailable()
  {
    cMethods.checkConnectivity(context);

    signUpFormValidation();
  }

  signUpFormValidation()
  {
    if(usernameTextEditingController.text.trim().length < 3)
    {
      cMethods.displaySnackBar("Your User Name must be atleast 4 or more characters.", context);
    }
    else if(phonenumberTextEditingController.text.trim().length > 10)
    {
      cMethods.displaySnackBar("Your Phone Number must be of 10 digits.", context);
    }
    else if(!emailTextEditingController.text.contains('@'))
    {
      cMethods.displaySnackBar("Please enter a valid Email ID", context);
    }
    else if(passwordTextEditingController.text.trim().length < 5)
    {
      cMethods.displaySnackBar("Your Password must atleast 6 or more characters.", context);
    }
    else
      {
        //register the user
        registerNewUser();
      }
  }

  registerNewUser() async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Please wait, while we register you..."),
    );

    final User? userFirebase = (
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
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

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
    Map userDataMap =
    {
      "name": usernameTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),
      "phone": phonenumberTextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no", //no means the account is approved
    };
    usersRef.set(userDataMap);

    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomePage()));
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Scrollbar(

      child:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [

           Image.asset(
          "assests/Images/ambulance.png"
        ),

             const Text(
                "Create a User's Account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //text fields + Sign In button
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                //Text Field for user name
                TextField(
                  controller: usernameTextEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "User Name",
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                      hintText: "Enter your Username",
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

                    //Text Field for Phone Number
                    TextField(
                      controller: phonenumberTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        hintText: "Enter your Phone Number",
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

                    //Text Field for Email
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "User Email",
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
                      onPressed: (){
                      checkIfNetworkIsAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12)
                      ),
                      child: const Text(
                        "Sign In"
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
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                },
                child: const Text(
                  "Already have an account? Login Here",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )

            ],
          ),
        ),
      )
    ));
  }
}
