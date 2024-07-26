import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/theme.dart';
import 'login_screen.dart';

class ChatScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;

  const ChatScreen(
      {super.key, required this.recipientId, required this.recipientName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) {
      return;
    }

    final chatId = currentUser!.uid.compareTo(widget.recipientId) > 0
        ? '${currentUser!.uid}-${widget.recipientId}'
        : '${widget.recipientId}-${currentUser!.uid}';

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'text': messageController.text,
      'senderId': currentUser?.uid,
      'receiverId': widget.recipientId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    messageController.clear();
  }

  Future<void> updateMessage(String messageId, String newText) async {
    final chatId = currentUser!.uid.compareTo(widget.recipientId) > 0
        ? '${currentUser!.uid}-${widget.recipientId}'
        : '${widget.recipientId}-${currentUser!.uid}';

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'text': newText,
    });
  }

  Future<void> deleteMessage(String messageId) async {
    final chatId = currentUser!.uid.compareTo(widget.recipientId) > 0
        ? '${currentUser!.uid}-${widget.recipientId}'
        : '${widget.recipientId}-${currentUser!.uid}';

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  void showOptions(BuildContext context, String messageId, String currentText) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController updateController =
                        TextEditingController(text: currentText);
                    return AlertDialog(
                      title: const Text('Update chat'),
                      content: TextField(
                        controller: updateController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter new message"),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (updateController.text.trim().isNotEmpty) {
                              updateMessage(
                                  messageId, updateController.text.trim());
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Update'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                deleteMessage(messageId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatId = currentUser!.uid.compareTo(widget.recipientId) > 0
        ? '${currentUser!.uid}-${widget.recipientId}'
        : '${widget.recipientId}-${currentUser!.uid}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeProvider.appColor,
        title: Text(widget.recipientName,style: ThemeProvider.titleStyle,),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.to(() => const LoginScreen());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final messageText = message['text'];
                    final messageSender = message['senderId'];
                    final messageId = message.id;
                    final messageTimestamp = message['timestamp'] != null
                        ? (message['timestamp'] as Timestamp).toDate()
                        : DateTime.now();
                    final isMe = currentUser?.uid == messageSender;

                    return GestureDetector(
                      onLongPress: () {
                        if (isMe) {
                          showOptions(context, messageId, messageText);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.blueAccent
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        messageText,
                                        style: TextStyle(
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${messageTimestamp.hour}:${messageTimestamp.minute}',
                                        style: TextStyle(
                                          color: isMe
                                              ? Colors.white70
                                              : Colors.black54,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: ThemeProvider.appColor),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
