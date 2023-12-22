import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application/chat/chat_service.dart';
import 'package:flutter_chat_application/components/chat_bubble.dart';
import 'package:flutter_chat_application/components/my_textfield.dart';

class ChatPage extends StatefulWidget {
  final String userEmail;
  final String recieverUserId;

  const ChatPage(
      {super.key, required this.recieverUserId, required this.userEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messagecontroller = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  void sendMessage() async {
    //only send if there is something to send
    if (_messagecontroller.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.recieverUserId, _messagecontroller.text);

      _messagecontroller.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF91AFDC),
        title: Text(widget.userEmail),
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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              Expanded(
                child: _buildMessageList(),
              ),

              _buildMessageInput(),

              const SizedBox(height: 25,),
            ],
          ),
        ],
      ),
    );

  }

  //build MessageList
  Widget _buildMessageList() {
    return StreamBuilder(stream: _chatService.getMessages(
        widget.recieverUserId, _firebaseAuth.currentUser!.uid),
        builder: (context,snapshot){
      if(snapshot.hasError){
        return Text('Error${snapshot.error}');
      }
      
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Text('Loading...');
      }

      return ListView(
        children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
      );
        });
  }


//build Message Item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(

      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5,),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }


  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(child: MyTextField(controller: _messagecontroller,
              hintText: 'Enter Messages',
              obscureText: false)),

          //send button
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward, size: 40,)),
        ],

        //send button
      ),
    );
  }
}
