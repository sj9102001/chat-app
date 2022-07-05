import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, i) {
            print(chatDocs[i]['userName']);

            return MessageBubble(
                message: chatDocs[i]['text'],
                userName: chatDocs[i]['userName'],
                isMe: FirebaseAuth.instance.currentUser!.uid ==
                        chatDocs[i]['userId']
                    ? true
                    : false);
          },
          itemCount: chatDocs.length,
        );
      },
    );
  }
}
