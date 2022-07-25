import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              // Header
              const Text('Signup', style: TextStyle(fontSize: 50.0)),

              // Signup fields
              Wrap(
                runSpacing: 20.0,
                children: [
                  Text(_error ?? '', style: const TextStyle(color: Colors.red),),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value == '') {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text('Password'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value == '') {
                        return 'Password is required';
                      }
                      return null;
                    }
                  ),
                  TextFormField(
                    controller: rePasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text('Password Confirm'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value == '') {
                        return 'Password confirm is required';
                      }else if (passwordController.text != rePasswordController.text) {
                        return 'Passwords aren\'t match';
                      }
                      return null;
                    }
                  ),
                ],
              ),

              // Singup button
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size?>(const Size(130.0, 60.0)),
                ),
                onPressed: () {
                  if(_formKey.currentState!.validate()) {
                    context.read<FirebaseAuthService>().signUp(
                      email: emailController.text.trim(),
                      password: passwordController.text
                    )
                    .then((value) { // show snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Singed up successfully!'),
                          action: SnackBarAction(
                            label: 'Login',
                            onPressed: () {
                              Navigator.pop(context); // Signup page always being accessed from login page
                            }
                          )
                        )
                      );
                    })
                    .catchError((error) => _error = error.message);
                  }
                },
                child: const Text('Signup', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      )
    );
  }
}