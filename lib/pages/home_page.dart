// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables

import 'package:chat_with_firebase/components/user_tile.dart';
import 'package:chat_with_firebase/pages/chat_page.dart';
import 'package:chat_with_firebase/services/auth/auth_service.dart';
import 'package:chat_with_firebase/components/my_drawer.dart';
import 'package:chat_with_firebase/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // void logout() {
  //   // get auth service
  //   final _auth = AuthService();
  //   _auth.signOut();
  // }

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Home"),
        foregroundColor: Colors.grey,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        // return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    if (userData["email"] != _authService.getCurrentUser()) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          // tapped on a user -> go to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverEmail: userData['email'],
                recieverID: userData['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
