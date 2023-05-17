import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sci_space_x/interface/Theme/themes.dart';
import 'package:sci_space_x/interface/screens/chat_screen.dart';
import 'package:sci_space_x/interface/screens/edit_profile_screen.dart';

import 'package:sci_space_x/interface/screens/login_screen.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/authentication.dart';
import 'chat_image_view.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  static String id = "UserInfoScreen";

  final User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User _user;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginScreen(),
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
  void initState() {
    _user = widget._user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.firebaseNavy,
        appBar: AppBar(
          backgroundColor: MyThemeData.of(context).secondaryBackground,
          centerTitle: true,
          title: Text(
            'WELCOME',
            style: MyThemeData.of(context).appBarTitle2,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          actions: [
            Row(
              children: [
                _isSigningOut
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () async {
                            setState(() {
                              _isSigningOut = true;
                            });
                            await Authentication.signOut(context: context);
                            setState(() {
                              _isSigningOut = false;
                            });
                            Navigator.of(context)
                                .pushReplacement(_routeToSignInScreen());
                          },
                        ),
                      ),
              ],
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(140.0),
            child: Container(
              padding: const EdgeInsets.only(left: 20, bottom: 40),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    height: 70,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Material(
                              color: CustomColors.firebaseGrey.withOpacity(0.3),
                              child: _user.photoURL == null
                                  ? const Icon(Icons.person_2_outlined)
                                  : Image.network(
                                      _user.photoURL!,
                                      fit: BoxFit.fitHeight,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 14,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(
                                    user: _user,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.green,
                              ),
                              child: const Icon(
                                size: 20.0,
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _user.displayName == null ? "..." : _user.displayName!
                            ..capitalizeFirst,
                          style: MyThemeData.of(context).appBarTitle,
                        ),
                        Text(
                          _user.email.toString(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: makeCard(
                      Icons.text_fields_sharp,
                      "SciSpaceX",
                      Colors.green.withOpacity(0.5),
                      () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              user: _user,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: makeCard(
                      Icons.image,
                      "Image Generation",
                      Colors.orange.withOpacity(0.5),
                      () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ChatImageView(
                              user: _user,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

Widget makeCard(var image, var text, var color, var callback) {
  return InkWell(
    onTap: callback,
    child: Card(
      color: color,
      child: Center(
        child: SizedBox(
          height: 180,
          width: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                image,
                color: Colors.white,
                size: 44,
              ),
              const SizedBox(height: 12),
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
