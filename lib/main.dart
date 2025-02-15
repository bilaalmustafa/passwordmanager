import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/firebase_options.dart';
import 'package:passwordmanager/view/Login_Screens/LogInProvider.dart';
import 'package:passwordmanager/view/Login_Screens/LoginScreen.dart';
import 'package:passwordmanager/view/Passwordmaneger/PasswordManegerProvider.dart';
import 'package:passwordmanager/view/SignUp_Screens/SignUpProvider.dart';
import 'package:passwordmanager/view/SignUp_Screens/SingnUpScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
        ChangeNotifierProvider(create: (context) => PasswordMngrProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
