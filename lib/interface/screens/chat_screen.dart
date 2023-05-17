import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sci_space_x/interface/screens/user_page.dart';

import '../../core/constants/constants.dart';
import '../../core/providers/chats_provider.dart';
import '../../core/providers/models_provider.dart';
import '../../core/services/assets_manager.dart';
import '../../core/services/services.dart';
import '../widgets/chat_widget.dart';
import '../widgets/text_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  static String id = "chat_screen";
  final User _user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isTyping = false;
  late User user;
  String imgurl = "https://yourimageshare.com/ib/YevOaEM0Fj";
  late TextEditingController textEditingController;
  late ScrollController listScrollController;
  late FocusNode focusNode;
  @override
  void initState() {
    user = widget._user;
    listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  Route _routeToUserScreenFrom() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => UserInfoScreen(
        user: user,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Text("SciSpaceX"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(_routeToUserScreenFrom());
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: listScrollController,
                  itemCount: chatProvider.getChatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      userIMG: user.photoURL == null ? imgurl : user.photoURL!,
                      msg: chatProvider
                          .getChatList[index].msg, // chatList[index].msg,
                      chatIndex: chatProvider.getChatList[index]
                          .chatIndex, //chatList[index].chatIndex,
                      shouldAnimate:
                          chatProvider.getChatList.length - 1 == index,
                    );
                  }),
            ),
            if (isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider,
                          );
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessageFCT(
                          modelsProvider: modelsProvider,
                          chatProvider: chatProvider,
                        );
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    listScrollController.animateTo(
      listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessageFCT({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider,
  }) async {
    if (isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      String texts = 'hello. world!';

      setState(() {
        isTyping = true;
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: modelsProvider.getCurrentModel,
      );

      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label: error.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(
        () {
          scrollListToEND();
          isTyping = false;
        },
      );
    }
  }
}
