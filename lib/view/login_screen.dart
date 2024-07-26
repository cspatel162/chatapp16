
import 'package:chatapp16/routes/AppRoutes.dart';
import 'package:chatapp16/view/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/elevated_button.dart';
import '../helper/text_button.dart';
import '../utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email and password cannot be empty');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.snackbar('Success', 'Login Successful');
      Get.to(() => UserListScreen());

    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'network-request-failed') {
        message = 'A network error occurred. Please try again.';
      } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Invalid email or password';
      } else if (e.message != null) {
        message = e.message!;
      }
      Get.snackbar('Error', message);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      setState(() {
        isLoading = false;
      });
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
        title: Text('Sign in'.tr, style: ThemeProvider.titleStyle),
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
                      heading1('Welcome Back!'.tr),
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
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                                decoration: textFieldDecoration(),
                                child: TextFormField(
                                  controller: emailController,
                                  cursorColor: ThemeProvider.appColor,
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                        fontSize: 14,
                                        color: ThemeProvider.greyColor),
                                    border: InputBorder.none,
                                    labelText: "Email Address".tr,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16),
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
                            MyTextButton(
                                onPressed: () => Get.to(() => AppRoutes.getSignupRoute()),
                                text: 'Don\'t have an account? Sign Up'.tr,
                                colors: ThemeProvider.appColor),
                            const SizedBox(height: 12),
                            if (isLoading)
                              const Center(child: CircularProgressIndicator()),
                            if (!isLoading)
                              MyElevatedButton(
                                onPressed: signIn,
                                color: ThemeProvider.appColor,
                                height: 45,
                                width: double.infinity,
                                child: Text('Login'.tr, style: const TextStyle(letterSpacing: 1, fontSize: 16, color: ThemeProvider.whiteColor, fontFamily: 'bold')),
                              ),
                          ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
