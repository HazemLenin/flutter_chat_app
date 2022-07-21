import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
  final authProvider = context.read<FirebaseAuthService>();
  final authChanges = context.watch<User?>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        actions: [
          
          // Signout button
          TextButton(
            onPressed: () {
              authProvider.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Login()));
            },
            child: const Text('Signout', style: TextStyle(color: Colors.white))
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Welcome ${authChanges?.email}', style: const TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}