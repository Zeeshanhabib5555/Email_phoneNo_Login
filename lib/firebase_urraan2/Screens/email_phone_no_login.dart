import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class EmailPhoneNoLogin extends StatefulWidget {
  const EmailPhoneNoLogin({Key? key}) : super(key: key);

  @override
  State<EmailPhoneNoLogin> createState() => _EmailPhoneNoLoginState();
}

class _EmailPhoneNoLoginState extends State<EmailPhoneNoLogin> {
  bool isCodeSent = false;

  var firebase_auth = FirebaseAuth.instance;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var codeController = TextEditingController();

  String verificationId = '';

  @override
  void initState() {
    super.initState();
  }

  PhoneNumberAuthCompleted(BuildContext context, String sms_code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: sms_code);
    firebase_auth
        .signInWithCredential(credential)
        .then((UserCredential userCredential) {
      print("object ${userCredential.user.toString()}");
      _showAlertDialog('Status', 'Login Through ${userCredential.user?.phoneNumber}');
    });
  }

  verifyPhoneNumber(BuildContext context) async {
    String phoneNo = phoneController.text.toString();
    //try, catch is used for error handling.
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '$phoneNo',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          this.verificationId = credential.verificationId!;

          setState(() {
            codeController.text = credential.smsCode!;
          });

          print("Hello Firebase Auth 1 ${credential.smsCode}");
          PhoneNumberAuthCompleted(context, credential.smsCode!);
        },
        verificationFailed: (FirebaseAuthException e) {
          print(
              "Hello Firebase Auth Verification Failed Called ${e.toString()}");
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          setState(() {
            isCodeSent = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
      );
    } catch (e) {
      print("hello firebaseAuth error called ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    GestureTapCallback onTapVerify = () {
      if (!isCodeSent) {
        verifyPhoneNumber(context);
      } else {
        String code_sms = codeController.text.toString();
        PhoneNumberAuthCompleted(context, code_sms);
      }

    };
    final _formKey = GlobalKey<FormState>();
    final _formKey1 = GlobalKey<FormState>();
    String _name = '';
    String _name1 = '';
   // String _password = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Center(
            child: Text(
          "Login Page",
          style: TextStyle(color: Colors.white),
        )),
      ),


      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
                child: Icon(Icons.account_circle_rounded,
                    size: 180, color: Colors.deepPurple)),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Email ",
                        hintText: "Login with email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null; // Return null if the input is valid
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                      controller: emailController,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Password ",
                        hintText: "Login with password",
                        border: OutlineInputBorder(),
                      ),

                      //Validator is used for when text is empty
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null; // Return null if the input is valid
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                      controller: passwordController,
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        String email = emailController.text.toString();
                        String password = passwordController.text.toString();

                        try {
                          await firebase_auth
                              .createUserWithEmailAndPassword(
                                  email: email, password: password)
                              .then((UserCredential user_credential) {
                            print("object ${user_credential.user.toString()}");
                            print(
                                "object ${user_credential.credential!.signInMethod}");
                            print("object ${user_credential.credential!.token}");
                            //Dialogue Box
                          }).onError((FirebaseAuthException error, stackTrace) {
                            if (error.code == "email-already-in-use") {
                              print(
                                  "This email is already in use you can use another email");
                            }
                          });
                        } catch (e) {
                          print("object error ${e.toString()}");
                          return;
                        }
                        _showAlertDialog('Status', 'First Enter email & password');
                      },
                      child: const Text("SignUp",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ))),
                  Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, save the form data
                              _formKey.currentState!.save();
                              // Now you can use the validated data, for example, submit it
                              print('Name: $_name');

                              String email = emailController.text.toString();
                              String password = passwordController.text
                                  .toString();

                              try {
                                await firebase_auth
                                    .signInWithEmailAndPassword(
                                    email: email, password: password)
                                    .then((UserCredential user_credential) {

                                  if(email==user_credential.user?.email){
                                    _showAlertDialog('Status', 'Login Through  ${user_credential.user?.email}');
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginHomePhEm()));
                                  }
                                  print("object ${user_credential.user
                                      .toString()}");
                                  print(
                                      "object ${user_credential.credential!
                                          .signInMethod}");
                                  print("object ${user_credential.credential!
                                      .token}");
                                }).onError((FirebaseAuthException error,
                                    stackTrace) {
                                  if (error.code == "email-already-in-use") {
                                    print(
                                        "This email is already in use you can use another email");
                                  }
                                });
                              } catch (e) {
                                print("object error ${e.toString()}");
                                return;
                              }
                              // _showAlertDialog('Status', 'Email Login Successfully');

                            }


                          }, child: const Text(
                        'Email Login',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                      )
                  ),
                ],
              ),
            ),
            const Text(
              'or',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey1,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone ",
                        hintText: "Login with Phone No",
                        border: OutlineInputBorder(),
                      ),
                      //Validator

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null; // Return null if the input is valid
                      },
                      onSaved: (value) {
                        _name1 = value!;
                      },
                      controller: phoneController,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Code ",
                        hintText: "Enter code here",
                        border: OutlineInputBorder(),
                      ),
                      //Validator

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your code';
                        }
                        return null; // Return null if the input is valid
                      },
                      onSaved: (value) {
                        _name1 = value!;
                      },
                      controller: codeController,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed:() {
                        onTapVerify();
                        if (_formKey1.currentState!.validate()) {
                          // If the form is valid, save the form data
                          _formKey1.currentState!.save();
                          // Now you can use the validated data, for example, submit it
                          print('Name1: $_name1');
                        }


                      }, child: Text(
                      isCodeSent ? 'verify code' : 'Phone Login',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      backgroundColor: const Color(0xFFB2DFDB),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
