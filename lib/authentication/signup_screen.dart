import 'package:driver_app/authentication/login_screen.dart';
import 'package:driver_app/methods/common_methods.dart';
import 'package:driver_app/pages/dashboard.dart';
import 'package:driver_app/widgets/loading_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  TextEditingController vehiclenumberTextTextEditEditingController = TextEditingController();
  //TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
  XFile? imageFile;
  String urlOfUploadedImage = "";


  checkIfNetworkIsAvailable()
  {
  //   cMethods.checkConnectivity(context);

    if(imageFile != null) //image validation
    {
      signUpFormValidation();
    }
    else
      {
        cMethods.displaySnackBar("Please choose an image first.",context);
      }
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
    else if(vehiclenumberTextTextEditEditingController.text.isEmpty)
    {
      cMethods.displaySnackBar("Your enter the vehicle number.", context);
    }
    else
      {
        uploadImageToStorage(); // we'll first move the image to storage after validating that all the credentials are filled.
      }
  }

  uploadImageToStorage() async
  {
    String imageIDName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImage = FirebaseStorage.instance.ref().child("Images").child(imageIDName);

    UploadTask uploadTask = referenceImage.putFile(File(imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    urlOfUploadedImage = await snapshot.ref.getDownloadURL();

    setState((){
      urlOfUploadedImage;
    });

    registerNewDriver();//register the user
  }

  registerNewDriver() async
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

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("drivers").child(userFirebase!.uid);

    Map driverCarInfo =
    {
      "vehicleNumber": vehiclenumberTextTextEditEditingController.text.trim(),
    };

    Map driverDataMap =
    {
      "photo": urlOfUploadedImage,
      "car_details": driverCarInfo,
      "name": usernameTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),
      "phone": phonenumberTextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no", //no means the account is approved
    };
    usersRef.set(driverDataMap);

    Navigator.push(context, MaterialPageRoute(builder: (c)=> Dashboard()));
  }

  chooseImageFromGallery() async
  {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(pickedFile != null)
      {
        setState((){
          imageFile = pickedFile;
        });
      }
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

              const SizedBox(
                height: 40,
              ),

              imageFile == null ?
              const CircleAvatar(
              radius: 86,
              backgroundImage: AssetImage("assests/images/avatarman.png"),
            ) : Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: FileImage(
                      File(
                      imageFile!.path,
                      ),
                    )
                  )
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              GestureDetector(
                onTap: ()
                {
                  chooseImageFromGallery();
                },
                child: const Text(
                  "Select Image",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
                    labelText: "Driver Name",
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

                    //Text Field for Vehicle Number
                    TextField(
                      controller: vehiclenumberTextTextEditEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Vehicle Number",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        hintText: "Enter your vehicle's number",
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
