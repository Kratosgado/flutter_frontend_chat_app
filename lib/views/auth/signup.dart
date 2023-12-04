import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/data/network/services/server.dart';
import 'package:flutter_frontend_chat_app/resources/color_manager.dart';
import 'package:flutter_frontend_chat_app/resources/components/action_button.dart';
import 'package:flutter_frontend_chat_app/resources/string_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';
import 'package:flutter_frontend_chat_app/views/auth/login.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              height: Spacing.s100 * 2.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Get.off(() => const LoginView()),
                          child: const Text(
                            'Login',
                          )),
                    ],
                  ),
                  actionButton(() {
                    if (_formKey.currentState!.validate()) {
                      ServerService().signUp(_emailController.text, _usernameController.text,
                          _passwordController.text);
                      debugPrint('Username: ${_usernameController.text}');
                      debugPrint('Email: ${_emailController.text}');
                      debugPrint('Password: ${_passwordController.text}');
                    }
                  })
                  // ElevatedButton(
                  //   child: const Text(
                  //     'Sign Up',
                  //     style: TextStyle(color: ColorManager.bgColor),
                  //   ),
                  //   onPressed: () {
                  //     if (_formKey.currentState!.validate()) {
                  //       debugPrint('Username: ${_usernameController.text}');
                  //       debugPrint('Email: ${_emailController.text}');
                  //       debugPrint('Password: ${_passwordController.text}');
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
