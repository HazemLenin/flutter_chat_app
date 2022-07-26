import 'package:chat_app/providers/dark_theme_provider.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/providers/message_provider.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/splash_screen.dart';
import 'services/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (context) => FirebaseAuthService(FirebaseAuth.instance) // make auth service accessable from other providers
        ),
        StreamProvider<User?>(
          create: (context) => context.read<FirebaseAuthService>().authStateChanges, // watches auth state from service provider
          initialData: null
        ),
        Provider<UserProvider>(create: (context) => UserProvider()),
        Provider<MessageProvider>(create: (context) => MessageProvider()),
        ChangeNotifierProvider<DarkThemeProvider>(create: (context) => DarkThemeProvider()),
      ],
      builder: (BuildContext context, child) => MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          brightness: Provider.of<DarkThemeProvider>(context).enabled ? Brightness.dark : Brightness.light,
          primarySwatch: Colors.red,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}