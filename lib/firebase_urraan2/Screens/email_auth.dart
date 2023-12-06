import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class EmailAuth extends StatefulWidget {
  const EmailAuth({Key? key}) : super(key: key);

  @override
  State<EmailAuth> createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var firebase_auth = FirebaseAuth.instance;

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Center(child: Text("Email page")),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter your email",
                labelText: "Email",
            ),
              controller: emailController,
            ),
            const SizedBox(height: 20,),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Enter your password",
                labelText: "Password",
              ),
              controller: passwordController,
            ),
            const SizedBox(height: 20,),
            TextButton(
                onPressed: ()async {

                  String email = emailController.text.toString();
                  String password = passwordController.text.toString();

                 try {
                await   firebase_auth.createUserWithEmailAndPassword(
                       email: email,
                       password: password).then((UserCredential user_credential){
                     print("object ${user_credential.user.toString()}");
                     print("object ${user_credential.credential!.signInMethod}");
                     print("object ${user_credential.credential!.token}");
                   }).onError((FirebaseAuthException error, stackTrace) {
                     if(error.code =="email-already-in-use"){
                       print("This email is already in use you can use another email");
                     }
                });
                 }
                 catch(e){
                   print("object error ${e.toString()}");
                   return;
                 }
                },
                child: const Text("SignUp",style: TextStyle(fontSize: 20),)
            ),
            SizedBox(height: 10,),

            TextButton(
                onPressed: ()async {

                  String email = emailController.text.toString();
                  String password = passwordController.text.toString();

                  try {
                    await   firebase_auth.signInWithEmailAndPassword(
                        email: email,
                        password: password)
                        .then((UserCredential user_credential){
                      print("object ${user_credential.user.toString()}");
                      print("object ${user_credential.credential!.signInMethod}");
                      print("object ${user_credential.credential!.token}");
                    }).onError((FirebaseAuthException error, stackTrace) {
                      if(error.code =="email-already-in-use"){
                        print("This email is already in use you can use another email");
                      }
                    });
                  }
                  catch(e){
                    print("object error ${e.toString()}");
                    return;
                  }
                },
                child: const Text("SignIn",style: TextStyle(fontSize: 20),)
            ),
            TextButton(
                onPressed: (){
                  try  {
                    firebase_auth.signOut();
                  }
                  catch(e) {
                    print("object error ${e.toString()}");
                    return;
                  }
                },
                child:  Text("SignOut",style: TextStyle(fontSize: 20),)
            ),
            SizedBox(height: 10,),
            TextButton(
                onPressed: ()  {
                  try{
                    // await firebase_auth.currentUser.toString();
                    print("object error ${firebase_auth.currentUser.toString()}");
                  }
                  catch(e){
                    print("object error ${e.toString()}");
                    return;
                  }
                },
                child:  Text("Current User",style: TextStyle(fontSize: 20),)
            ),
            SizedBox(height: 10,),
            TextButton(
                onPressed: (){
                  try{
                   firebase_auth.signInAnonymously().then((value) {
                     print(firebase_auth.currentUser.toString());
                   }).onError((FirebaseAuthException error, stackTrace) {
                     if(error.code =="to many request"){
                       print("Access this account is temporary disable");
                     }
                     else if(error.code == "wrong password"){
                       print("The password is invalid and user cannot have a password");
                     }
                   });
                  }
                  catch(e){
                    print("Error during anonymous sign-in: $e");
                    return;
                  }
                },
                child:  Text("Anonymous",style: TextStyle(fontSize: 20),)
            ),
          ],
        ),
      ),
    );
  }
}
