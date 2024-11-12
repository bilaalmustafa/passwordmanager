import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passwordmanager/component/Custom_Button.dart';
import 'package:passwordmanager/component/Custom_Icon.dart';
import 'package:passwordmanager/component/Custom_textField.dart';
import 'package:passwordmanager/view/Login_Screens/LogInProvider.dart';
import 'package:passwordmanager/view/Login_Screens/LoginScreen.dart';
import 'package:passwordmanager/view/Passwordmaneger/PasswordManegerProvider.dart';
import 'package:provider/provider.dart';

class PasswardManegerScreen extends StatefulWidget {
  const PasswardManegerScreen({super.key});

  @override
  State<PasswardManegerScreen> createState() => _PasswardManegerScreenState();
}

class _PasswardManegerScreenState extends State<PasswardManegerScreen> {
  // Define a global key to control the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? userId = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final passProvider =
        Provider.of<PasswordMngrProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(userId?.uid) // Assuming the document ID is the UID
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Error fetching user data',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text(
                      'User data not found',
                      style: TextStyle(color: Colors.white60),
                    ),
                  );
                }

                // var userData = snapshot.data!.data() as Map<String, dynamic>;

                return UserAccountsDrawerHeader(
                  accountName: Text(snapshot.data!['userName'] ?? 'Hi User',
                      style: const TextStyle(color: Colors.white60)),
                  accountEmail: Text(
                      snapshot.data!['UserEmail'] ?? 'user@example.com',
                      style: const TextStyle(color: Colors.white60)),
                  currentAccountPicture: Stack(
                    children: [
                      CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.black,
                          backgroundImage:
                              NetworkImage(snapshot.data!['image']),
                          child: snapshot.data!['image'] == ''
                              ? Text(
                                  snapshot.data!['userName']?.substring(0, 1),
                                  style: const TextStyle(
                                      fontSize: 40.0, color: Colors.red),
                                )
                              : null
                          // backgroundImage:
                          // AssetImage('Assets/Images/person.png'),

                          // child:
                          ),
                      Positioned(
                        left: 5,
                        child: InkWell(
                          onTap: () {
                            imagePicker();
                          },
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white60),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white60),
                ),
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                      loginProvider.loginemailcontroller.clear();
                      loginProvider.loginpasswordcontroller.clear();
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign out failed: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white12,
      body: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Color.fromRGBO(183, 28, 28, 1)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: const Icon(
                        Icons.menu,
                        color: Colors.black,
                      )),
                  const SizedBox(width: 35),
                  const Text(
                    'Password Manager',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('passwords')
                  .where('UserId', isEqualTo: userId!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Error fetching data',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.red.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black54,
                          child: Text(
                            doc['category'][0].toString(),
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white60,
                            ),
                          ),
                        ),
                        title: Text(
                          doc['category'].toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white60,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc['UserEmail'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                            Text(
                              doc['password'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                        trailing: Wrap(
                          children: [
                            customIcon(
                              icon: Icons.edit,
                              onTap: () {
                                String category = doc['category'].toString();
                                String email = doc['UserEmail'].toString();
                                String passwrd = doc['password'].toString();
                                sHowBottomSheet(
                                  context,
                                  category,
                                  email,
                                  passwrd,
                                  'update',
                                  userId!.uid, // Pass the document ID
                                );
                              },
                            ),
                            customIcon(
                              icon: Icons.delete,
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('passwords')
                                    .doc(userId!
                                        .uid) // Use the document ID for deletion
                                    .delete();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(183, 28, 28, 1),
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 40,
        ),
        onPressed: () {
          String category = passProvider.passAccountController.text.trim();
          String userEmail = passProvider.passAccountController.text.trim();
          String userPasswrd = passProvider.passAccountController.text.trim();
          sHowBottomSheet(
              context, category, userEmail, userPasswrd, 'added', userId!.uid);
        },
      ),
    );
  }

  void sHowBottomSheet(
    BuildContext context,
    String category,
    String userEmail,
    String userPasswrd,
    String condition,
    String docId, // Include the document ID for updating
  ) {
    TextEditingController categoryController =
        TextEditingController(text: category);
    TextEditingController emailController =
        TextEditingController(text: userEmail);
    TextEditingController passwordController =
        TextEditingController(text: userPasswrd);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(183, 28, 28, 1),
                    Colors.black,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Add Your Account',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: categoryController,
                          title: 'Category',
                          icon: Icons.account_box,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: CustomTextField(
                            controller: emailController,
                            title: 'Email',
                            icon: Icons.email,
                          ),
                        ),
                        CustomTextField(
                          controller: passwordController,
                          title: 'Password',
                          icon: Icons.password,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: CustomButton(
                            title: condition == 'added' ? 'Add' : 'Update',
                            onTap: () async {
                              try {
                                if (categoryController.text.trim().isEmpty ||
                                    emailController.text.trim().isEmpty ||
                                    passwordController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please fill in all fields'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                if (condition == 'added') {
                                  await FirebaseFirestore.instance
                                      .collection('passwords')
                                      .doc()
                                      .set({
                                    'category': categoryController.text.trim(),
                                    'UserEmail': emailController.text.trim(),
                                    'password': passwordController.text.trim(),
                                    'UserId': docId,
                                    'CreateAt': DateTime.now(),
                                  });
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('passwords')
                                      .doc(
                                          docId) // Use the document ID for updating
                                      .update({
                                    'category': categoryController.text.trim(),
                                    'UserEmail': emailController.text.trim(),
                                    'password': passwordController.text.trim(),
                                    'CreateAt': DateTime.now(),
                                  });
                                }

                                categoryController.clear();
                                emailController.clear();
                                passwordController.clear();
                                Navigator.pop(
                                    context); // Close the bottom sheet
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Failed to add/update data: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void imagePicker() async {
    print('kegee');
    String imageURL = '';
    ImagePicker imagepicker = ImagePicker();
    XFile? file = await imagepicker.pickImage(source: ImageSource.camera);
    print('2 kegee');
    //if (file == null) return;
    //Unique name of image
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();

    //uplaod image to firebase
    Reference referenceRoot = FirebaseStorage.instance.ref();
    //create folder for image
    Reference referenceDirImage = referenceRoot.child('images');
    //Give pic a unique name
    Reference imagetoUpload = referenceDirImage.child(uniqueName);
    //uplaod image to firebase

    try {
      await imagetoUpload.putFile(File(file!.path));
      imageURL = await imagetoUpload.getDownloadURL();
      print('dalta razi');

      FirebaseFirestore.instance
          .collection('Users')
          .doc(userId!.uid)
          .update({'image': imageURL}).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image uploaded Successful!'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      });
    } catch (e) {
      print(e);
    }
  }
}
