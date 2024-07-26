import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  Future<void> signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'mobileNumber': mobileNumberController.text,
      });
      Get.snackbar('Success', 'Account created successfully');
      Get.to(() => LoginScreen());

    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      Get.snackbar('Error', e.message ?? 'An error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeProvider.appColor,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
        elevation: 0,
        centerTitle: true,
        title: Text('Sign up'.tr, style: ThemeProvider.titleStyle),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      heading1('Create an Account'.tr),
                      const SizedBox(height: 6),
                      lightText('Fill in the details below to sign up'.tr),
                      const SizedBox(height: 20)
                    ]),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: myBoxDecoration(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: textFieldDecoration(),
                                child: TextFormField(
                                  controller: nameController,
                                  cursorColor: ThemeProvider.appColor,
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                        fontSize: 14,
                                        color: ThemeProvider.greyColor),
                                    border: InputBorder.none,
                                    labelText: "Name".tr,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: textFieldDecoration(),
                                child: TextFormField(
                                  controller: emailController,
                                  cursorColor: ThemeProvider.appColor,
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                        fontSize: 14,
                                        color: ThemeProvider.greyColor),
                                    border: InputBorder.none,
                                    labelText: "Email".tr,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: textFieldDecoration(),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  cursorColor: ThemeProvider.appColor,
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                        fontSize: 14,
                                        color: ThemeProvider.greyColor),
                                    border: InputBorder.none,
                                    labelText: "Password".tr,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: textFieldDecoration(),
                                child: TextFormField(
                                  controller: mobileNumberController,
                                  cursorColor: ThemeProvider.appColor,
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                        fontSize: 14,
                                        color: ThemeProvider.greyColor),
                                    border: InputBorder.none,
                                    labelText: "Mobile Number".tr,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: signUp,
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(ThemeProvider.appColor),
                              ),
                              child: Text('Sign up'.tr),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => LoginScreen());
                },
                child: Text('Already have an account? Sign in'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
