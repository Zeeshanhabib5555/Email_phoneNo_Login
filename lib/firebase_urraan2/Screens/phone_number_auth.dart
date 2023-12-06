import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({Key? key}) : super(key: key);

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  var phoneNumberController = TextEditingController();
  var codeController = TextEditingController();

  var firebase_auth = FirebaseAuth.instance;
  String verificationId = '';

  bool isCodeSent = false;

  @override
  void initState() {
    super.initState();
  }

  PhoneNumberAuthCompleted(BuildContext context, String sms_code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: sms_code);
    firebase_auth.signInWithCredential(credential).then((UserCredential userCredential){
      print("object ${userCredential.user.toString()}");

    });
  }

  verifyPhoneNumber(BuildContext context) async {
    String phoneNo = phoneNumberController.text.toString();
    //try, catch is used for error handling.
    try{
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '$phoneNo',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {

          this.verificationId = credential.verificationId!;

          setState(() {
            codeController.text = credential.smsCode!;
          });

          print("Hello Firebase Auth 1 ${credential.smsCode}");
          PhoneNumberAuthCompleted(context,credential.smsCode!);
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Hello Firebase Auth Verification Failed Called ${e.toString()}");
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

    }
    catch(e){
      print("hello firebaseAuth error called ${e.toString()}");

    }
  }


  @override
  Widget build(BuildContext context) {
    GestureTapCallback onTapVerify = (){
      if(!isCodeSent){
        verifyPhoneNumber(context);
      }
      else{
        String code_sms = codeController.text.toString();
        PhoneNumberAuthCompleted(context,code_sms);
      }
    };

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Center(child: Text("Phone page")),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "Enter phone number",
                      labelText: "phone",
                    ),
                    controller: phoneNumberController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "Enter Verification code",
                      labelText: "code",
                    ),
                    controller: codeController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: onTapVerify,

                      child:  Text(
                        isCodeSent ? 'verify code' : 'Verify Phone Number',
                        style: TextStyle(fontSize: 20),
                      )
                  ),
                ])));
  }
}
