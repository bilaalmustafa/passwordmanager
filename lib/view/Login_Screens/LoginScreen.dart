import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/component/Custom_Button.dart';
import 'package:passwordmanager/component/Custom_TextButton.dart';
import 'package:passwordmanager/component/Custom_textField.dart';
import 'package:passwordmanager/view/Login_Screens/LogInProvider.dart';
import 'package:passwordmanager/view/Passwordmaneger/PasswordManegerScreen.dart';
import 'package:passwordmanager/view/SignUp_Screens/SingnUpScreen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final loginProvider =
        Provider.of<LogInControllerPrivoder>(context, listen: false);
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
                  padding: const EdgeInsets.only(top: 60),
                  child: CustomTextField(
                    controller: loginProvider.loginemailcontroller,
                    title: 'Email',
                    icon: Icons.email,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 40),
                  child: CustomTextField(
                    controller: loginProvider.loginpasswordcontroller,
                    title: 'Password',
                    icon: Icons.visibility_outlined,
                  ),
                ),
                CustomButton(
                  title: 'Log In',
                  onTap: () async {
                    try {
                      if (loginProvider.loginemailcontroller.text.isEmpty ||
                          loginProvider.loginpasswordcontroller.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please fill in all fields'),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }

                      if (loginProvider.loginemailcontroller.text.length < 6) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Password must be at least 6 characters long'),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: loginProvider.loginemailcontroller.text
                                  .toString()
                                  .trim(),
                              password: loginProvider
                                  .loginpasswordcontroller.text
                                  .toString()
                                  .trim())
                          .then((value) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const PasswardManegerScreen();
                        }));
                      });
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to LogIn'),
                          backgroundColor: Colors.red));
                    }
                  },
                ),
                CustomTextButton(
                  txt: 'You have no account ',
                  txtBtn: ' Sign up',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SignUPScreen();
                    }));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
