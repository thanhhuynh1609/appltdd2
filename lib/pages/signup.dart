import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:shopping_app/pages/bottomnav.dart';
import 'package:shopping_app/pages/login.dart';
import 'package:shopping_app/pages/widget/support_widget.dart';
import 'package:shopping_app/services/database.dart';
import 'package:shopping_app/services/shared_pref.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name, email, password;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password != null && name != null && email != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Registered Successfully!",
              style: TextStyle(fontSize: 20)),
        ));

        String id = userCredential.user!.uid;

        await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferenceHelper().saveUserId(id);
        await SharedPreferenceHelper().saveUserName(namecontroller.text);
        await SharedPreferenceHelper().saveUserImage(
            "https://firebasestorage.googleapis.com/v0/b/barberapp-ebcc1.appspot.com/o/icon1.png?alt=media&token=0fad24a5-a01b-4d67-b4a0-676fbc75b34a");

        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Id": id,
          "Image":
              "https://firebasestorage.googleapis.com/v0/b/barberapp-ebcc1.appspot.com/o/icon1.png?alt=media&token=0fad24a5-a01b-4d67-b4a0-676fbc75b34a"
        };

        await DatabaseMethods().addUserDetails(userInfoMap, id);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Bottomnav()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Password Provided is too Weak",
                style: TextStyle(fontSize: 20)),
          ));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Account Already exists",
                style: TextStyle(fontSize: 20)),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width, // Full chiều ngang
        height: MediaQuery.of(context).size.height, // Full chiều cao
        child: Row(
          children: [
            // Phần bên trái: Hình ảnh
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/login.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Phần bên phải: Form đăng ký
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Create an account to get started!",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        controller: namecontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Name",
                          hintText: "Enter your name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.person),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: mailcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter your email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.email),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: passwordcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter your password';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.lock),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                name = namecontroller.text;
                                email = mailcontroller.text;
                                password = passwordcontroller.text;
                              });
                              registration();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => Login()));
                            },
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:random_string/random_string.dart';
// import 'package:shopping_app/pages/bottomnav.dart';
// import 'package:shopping_app/pages/login.dart';
// import 'package:shopping_app/pages/widget/support_widget.dart';
// import 'package:shopping_app/services/database.dart';
// import 'package:shopping_app/services/shared_pref.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   String? name, email, password;
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController mailcontroller = TextEditingController();
//   TextEditingController passwordcontroller = TextEditingController();

//   final _formkey = GlobalKey<FormState>();

//   registration() async {
//     if (password != null && name != null && email != null) {
//       try {
//         UserCredential userCredential = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(email: email!, password: password!);

//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.redAccent,
//           content: Text("Registered Successfully!",
//               style: TextStyle(fontSize: 20)),
//         ));

//         // Sử dụng UID từ Firebase Auth thay vì randomAlphaNumeric
//         String id = userCredential.user!.uid;

//         await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
//         await SharedPreferenceHelper().saveUserId(id);
//         await SharedPreferenceHelper().saveUserName(namecontroller.text);
//         await SharedPreferenceHelper().saveUserImage(
//             "https://firebasestorage.googleapis.com/v0/b/barberapp-ebcc1.appspot.com/o/icon1.png?alt=media&token=0fad24a5-a01b-4d67-b4a0-676fbc75b34a");

//         Map<String, dynamic> userInfoMap = {
//           "Name": namecontroller.text,
//           "Email": mailcontroller.text,
//           "Id": id,
//           "Image":
//               "https://firebasestorage.googleapis.com/v0/b/barberapp-ebcc1.appspot.com/o/icon1.png?alt=media&token=0fad24a5-a01b-4d67-b4a0-676fbc75b34a"
//         };

//         await DatabaseMethods().addUserDetails(userInfoMap, id);
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => Bottomnav()));
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'weak-password') {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.redAccent,
//             content: Text("Password Provided is too Weak",
//                 style: TextStyle(fontSize: 20)),
//           ));
//         } else if (e.code == "email-already-in-use") {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.redAccent,
//             content: Text("Account Already exists",
//                 style: TextStyle(fontSize: 20)),
//           ));
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 40),
//           child: Form(
//             key: _formkey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Image.asset("images/login.png"),
//                 Center(
//                     child: Text("Sign Up", style: AppWidget.semiboldTextFeildStyle())),
//                 SizedBox(height: 20),
//                 Text("Please enter the details below to\n                     continue.",
//                     style: AppWidget.lightTextFeildStyle()),
//                 SizedBox(height: 40),
//                 Text("Name", style: AppWidget.semiboldTextFeildStyle()),
//                 SizedBox(height: 20),
//                 Container(
//                   padding: EdgeInsets.only(left: 20),
//                   decoration: BoxDecoration(
//                       color: Color(0xfff4f5f9), borderRadius: BorderRadius.circular(10)),
//                   child: TextFormField(
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please Enter your name';
//                       }
//                       return null;
//                     },
//                     controller: namecontroller,
//                     decoration: InputDecoration(border: InputBorder.none, hintText: "Name"),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text("Email", style: AppWidget.semiboldTextFeildStyle()),
//                 SizedBox(height: 20),
//                 Container(
//                   padding: EdgeInsets.only(left: 20),
//                   decoration: BoxDecoration(
//                       color: Color(0xfff4f5f9), borderRadius: BorderRadius.circular(10)),
//                   child: TextFormField(
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please Enter your email';
//                       }
//                       return null;
//                     },
//                     controller: mailcontroller,
//                     decoration: InputDecoration(border: InputBorder.none, hintText: "Email"),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text("Password", style: AppWidget.semiboldTextFeildStyle()),
//                 SizedBox(height: 20),
//                 Container(
//                   padding: EdgeInsets.only(left: 20),
//                   decoration: BoxDecoration(
//                       color: Color(0xfff4f5f9), borderRadius: BorderRadius.circular(10)),
//                   child: TextFormField(
//                     obscureText: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please Enter your password';
//                       }
//                       return null;
//                     },
//                     controller: passwordcontroller,
//                     decoration: InputDecoration(border: InputBorder.none, hintText: "Password"),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 GestureDetector(
//                   onTap: () {
//                     if (_formkey.currentState!.validate()) {
//                       setState(() {
//                         name = namecontroller.text;
//                         email = mailcontroller.text;
//                         password = passwordcontroller.text;
//                       });
//                     }
//                     registration();
//                   },
//                   child: Center(
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 2,
//                       padding: EdgeInsets.all(18),
//                       decoration: BoxDecoration(
//                           color: Colors.green, borderRadius: BorderRadius.circular(20)),
//                       child: Center(
//                           child: Text("SIGN UP",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold))),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("Already have an account? ",
//                         style: AppWidget.lightTextFeildStyle()),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context, MaterialPageRoute(builder: (context) => Login()));
//                       },
//                       child: Text("Sign in",
//                           style: TextStyle(
//                               color: Colors.green,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold)),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// } 












