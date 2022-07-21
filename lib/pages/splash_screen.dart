import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (() => checkAuthentication()));
  }

  Future<void> checkAuthentication() async {
    final firebaseUser = Provider.of<User?>(context, listen: false); // don't listen as we don't need to rebuild widget

    if (firebaseUser != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.message,
        size: 150.0,
        color: Colors.red,
      ),
    );
  }
}


// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final firebaseUser = context.watch<User?>();
//     if (firebaseUser != null) {
//       return const Home();
//     } else {
//       return const Login();
//     }
//   }
// }