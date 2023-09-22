import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sci_space_x/interface/screens/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/image_card.dart';
import '../widgets/search_text_field_widget.dart';
import '../../core/controllers/chat_image_controller.dart';

class ChatImageView extends StatefulWidget {
  const ChatImageView({Key? key, required User user})
      : _user = user,
        super(key: key);

  static String id = "chat_image_view";
  final User _user;
  @override
  _ChatImageViewState createState() => _ChatImageViewState();
}

class _ChatImageViewState extends State<ChatImageView> {
  late SharedPreferences _prefs;

  final ChatImageController _controller = ChatImageController();
  late User _user;
  @override
  void initState() {
    _user = widget._user;

    super.initState();
    // _controller.getGenerateImages("cat");
  }

  // Future<void> _initPrefs() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   String savedState = _prefs.getString('imageViewState') ?? '';
  //   _controller.state = savedState.isNotEmpty ? savedState : ApiState.initial;
  // }

  Future<void> _saveState(String state) async {
    await _prefs.setString('imageViewState', state);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Route _routeToUserScreenFromr() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => UserInfoScreen(
        user: _user,
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.withOpacity(0.8),
          title: const Text('Images Generator'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              if (_controller.state.value != ApiState.loading) {
                Navigator.of(context)
                    .pushReplacement(_routeToUserScreenFromr());
              }
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Center(
                    child: _controller.state.value == ApiState.loading
                        ? const CircularProgressIndicator()
                        : _controller.state.value == ApiState.success
                            ? ImageCard(
                                images: _controller.images,
                                user: _user,
                              )
                            : _controller.state.value == ApiState.notFound
                                ? const Text(
                                    "Search whatever you want.",
                                    textAlign: TextAlign.center,
                                  )
                                : const Text(
                                    "Image Generation Failed!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(height: 2),
                                  ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Row(
                  children: [
                    Expanded(
                      child: SearchTextFieldWidget(
                        color: Colors.orange.withOpacity(0.8),
                        textEditingController: _controller.searchTextController,
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: _controller.state.value == ApiState.loading
                          ? null
                          : () {
                              _controller.getGenerateImages(
                                _controller.searchTextController.text,
                              );
                              FocusScope.of(context)
                                  .unfocus(); // Remove focus from the text field
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: _controller.state.value == ApiState.loading
                            ? const CircularProgressIndicator()
                            : const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    const SizedBox(width: 6)
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
