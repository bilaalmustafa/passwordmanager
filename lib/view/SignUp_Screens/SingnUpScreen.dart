import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/component/Custom_Button.dart';
import 'package:passwordmanager/component/Custom_TextButton.dart';
import 'package:passwordmanager/component/Custom_textField.dart';
import 'package:passwordmanager/view/Login_Screens/LoginScreen.dart';
import 'package:provider/provider.dart';

class SignUPScreen extends StatefulWidget {
  const SignUPScreen({super.key});

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  @override
  Widget build(BuildContext context) {
    final signupProvider =
        Provider.of<SignUpControllerPrivoder>(context, listen: false);
    return Scaffold(
      body: Container(
        // width: double.infinity,
        // height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.red.shade900]),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 3)),
                    child: const Icon(
                      Icons.lock_open_sharp,
                      color: Colors.black,
                      size: 100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60, bottom: 10),
                    child: CustomTextField(
                      controller: signupProvider.signupuserController,
                      title: 'User name',
                      icon: Icons.verified_user,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CustomTextField(
                      controller: signupProvider.signupemailController,
                      title: 'Email',
                      icon: Icons.email,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: CustomTextField(
                      controller: signupProvider.signuppasswordController,
                      title: 'Password',
                      icon: Icons.visibility_outlined,
                    ),
                  ),
                  CustomButton(
                    title: 'Sign up',
                    onTap: () async {
                      try {
                        String userName =
                            signupProvider.signupuserController.text.trim();
                        String userEmail =
                            signupProvider.signupemailController.text.trim();
                        String userPasswrd =
                            signupProvider.signuppasswordController.text.trim();

                        if (userEmail.isEmpty || userPasswrd.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please fill in all fields'),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }

                        if (userPasswrd.length < 6) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'Password must be at least 6 characters long'),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }

                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: userEmail.toString().trim(),
                                password: userPasswrd.toString().trim())
                            .then((value) {
                          User? userId = FirebaseAuth.instance.currentUser;

                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(userId!.uid)
                              .set({
                            'userName': userName,
                            'UserEmail': userEmail,
                            'UserId': userId!.uid,
                            'image': '',
                            'CreateAt': DateTime.now(),
                          });
                        }).then((value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const LoginScreen();
                          }));
                          signupProvider.signupuserController.clear();
                          signupProvider.signupemailController.clear();
                          signupProvider.signuppasswordController.clear();
                        });
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to sign up: ${e.toString()}'),
                            backgroundColor: Colors.red));
                      }
                    },
                  ),
                  CustomTextButton(
                    txt: 'You have an account ',
                    txtBtn: ' Login',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
