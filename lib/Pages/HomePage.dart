import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application/Pages/chat_page.dart';
import 'package:flutter_chat_application/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.Signout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF98C1D9), // Change the background color
        elevation: 5, // Add elevation for a shadow effect
        title: Text(
          "SnapTalk",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Change the text color
          ),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(
              Icons.logout,
              color: Colors.white, // Change the icon color
            ),
          ),
        ],
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), // Adjust the radius as needed
            bottomRight: Radius.circular(20),
          ),
        ),
      ),

      body: Stack(
        children: [

          // Background Image
          // Main Content
          Container(
            color: Color(0xFF131924), // Make the container transparent
            child: _buildUserList(),
          ),
        ],
      ),
    );
  }
  //build a list of user accept for the current logged in user\
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading.....');
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: snapshot.data!.docs
                  .map<Widget>((doc) => _buildUserListItem(doc))
                  .toList(),
            ),
          );
        });
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    return Card(
      elevation: 0, // Increase elevation for a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
      ),
      color: Colors.blue,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          data['email'],
          style: TextStyle(
            color: Colors.black, // Change text color
            fontWeight: FontWeight.bold,
          ),
        ),
        tileColor: Color(0xFFE0FBFC),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverUserId: data['uid'],
                userEmail: data['email'],
              ),
            ),
          );
        },
      ),
    );

  }
}

