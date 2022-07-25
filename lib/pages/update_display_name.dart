// import 'package:flutter/cupertino.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_auth_service.dart';
import 'home.dart';

class UpdateDisplayName extends StatefulWidget {
  const UpdateDisplayName({Key? key}) : super(key: key);

  @override
  State<UpdateDisplayName> createState() => _UpdateDisplayNameState();
}

class _UpdateDisplayNameState extends State<UpdateDisplayName> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<FirebaseAuthService>();
    final userProvider = context.read<UserProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Update your display name', style: TextStyle(fontSize: 40.0),),

              TextFormField(
                controller: displayNameController,
                decoration: const InputDecoration(
                  label: Text('Display Name'),
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value == '') {
                    return 'Display name is required';
                  }
                  return null;
                }
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size?>(const Size(130.0, 60.0)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    authProvider.currentUser?.updateDisplayName(displayNameController.text.trim())
                    .then((value) {
                      userProvider.setUser(UserModel(
                        uid: authProvider.currentUser?.uid ?? '',
                        email: authProvider.currentUser?.email ?? '',
                        displayName: authProvider.currentUser?.displayName ?? ''
                      ));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
                    });
                  }
                },
                child: const Text('Update', style: TextStyle(fontSize: 20.0),),
              ),
            ],
          ),
        ),
      )
    );
  }
}