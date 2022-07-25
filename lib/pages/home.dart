import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import '../models/user_model.dart';
import './update_display_name.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<FirebaseAuthService>();
    final userProvider = context.read<UserProvider>();

    if (authProvider.currentUser?.displayName == null || authProvider.currentUser?.displayName == '') {
      return const UpdateDisplayName();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchPeoplDelegate());
            },
            icon: const Icon(Icons.search),
          ),

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

        // Stream all users
      body: StreamBuilder<List<UserModel>>(
        stream: userProvider.users,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                if (snapshot.data?[index].uid == authProvider.currentUser?.uid) {
                  return Container();
                }
                return Wrap(
                  children: [
                    ListTile(
                      title: Text(snapshot.data?[index].displayName ?? ''),
                    ),
                    const Divider(),
                  ]
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      )
    );
  }
}

class SearchPeoplDelegate extends SearchDelegate {
  final UserProvider userProvider = UserProvider();

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    onPressed: () {
      close(context, null);
    },
    icon: const Icon(Icons.arrow_back),
  );

  @override
  List<Widget> buildActions(BuildContext context) => <IconButton>[
    IconButton(
      onPressed: () {
        query = '';
      },
      icon: const Icon(Icons.clear),
    ),
  ];
  
  @override
  Widget buildSuggestions(BuildContext context) {
    Stream<List<UserModel>> suggestionsStream = userProvider.filterUsersEmail(query);

    return StreamBuilder<List<UserModel>>(
      stream: suggestionsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].email),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);
}