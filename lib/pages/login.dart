import 'package:chat_app/pages/home.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'singup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Header
              const Text('Login', style: TextStyle(fontSize: 50.0),),

              // Login fields
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
                      if (value == null || value == '' || !EmailValidator.validate(value)) {
                        return 'Enter valid email';
                      }
                      return null;
                    }
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      label: Text('Password'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value == '') {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  // Signup option button
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const Signup()));
                    },
                    child: const Text('Signup?')
                  ),
                ],
              ),
              
              // Login button
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size?>(const Size(130.0, 60.0)),
                ),
                onPressed: () {
                  if(_formKey.currentState!.validate()) {
                    setState(() {
                      _error = null;
                    });
                    context.read<FirebaseAuthService>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim()
                    )
                    .then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home())))
                    .catchError((error) {
                      setState(() {
                        _error = error.message;
                      });
                    });
                  }
                },
                child: const Text('Login', style: TextStyle(fontSize: 20.0),),
              ),
            ],
          ),
        )
      ),
    );
  }
}