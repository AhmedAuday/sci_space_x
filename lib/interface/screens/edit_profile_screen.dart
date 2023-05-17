import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sci_space_x/interface/Theme/themes.dart';
import 'package:sci_space_x/interface/screens/user_page.dart';

import '../../core/constants/constants.dart';
import '../../core/custom_clippers/custom_clipping.dart';

import '../../core/helper/show_snakbar.dart';
import '../../core/utils/my_theme.dart';
import '../widgets/custom_text_filedd.dart';
import '../widgets/profile_header.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required User user})
      : _user = user,
        super(key: key);
  final User _user;
  static String id = "editprofile";

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>
    with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> formKey = GlobalKey();
  late User _user;

  String ImgLL =
      "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png";

  String? email, password, passwordConf, name;
  AnimationController? _animationController;
  Animation<double>? _headerTextAnimation;

  bool obs = false;

  bool formValidate = false;

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPasswordConf = TextEditingController();

  bool passwordVisible = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _user = widget._user;
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: kLoginAnimationDuration,
    );
  }

  Route _routeToUserScreen() {
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
  void dispose() {
    // _animationController!.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: kWhite,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: MyTheme.themeColor,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(_routeToUserScreen());
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: CustomClipping(),
                      child: Container(
                        height: 175,
                        width: MediaQuery.of(context).size.width,
                        color: MyThemeData.of(context).tertiaryColor,
                      ),
                    ),
                    HeaderE(
                      img: _user.photoURL ?? ImgLL,
                      welcome: 'Edit Profile',
                      // animation: _headerTextAnimation!,
                      isLogin: true,
                    ),
                    Positioned(
                      bottom: 30,
                      right: 120,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: CustomFormTextField(
                    controller: controllerName,
                    hintText: _user.displayName,
                    prifix: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (data) {
                      name = data;
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: CustomFormTextField(
                    controller: controllerEmail,
                    hintText: _user.email,
                    prifix: const Icon(
                      Icons.mail,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (data) {
                      email = data;
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: CustomFormTextField(
                    controller: controllerPassword,
                    hintText: "Password",
                    prifix: const Icon(
                      Icons.password,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (data) {
                      password = data;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obs = !obs;
                          passwordVisible = !passwordVisible;
                        });
                      },
                      icon: passwordVisible
                          ? const Icon(
                              Icons.visibility,
                              color: Colors.black45,
                            )
                          : const Icon(
                              Icons.visibility_off,
                              color: Colors.black54,
                            ),
                    ),
                    obs: obs,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: CustomFormTextField(
                    controller: controllerPasswordConf,
                    hintText: "Password Conformation",
                    prifix: const Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (data) {
                      passwordConf = data;
                    },
                    obs: true,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle cancel button pressed
                          // Add your logic here
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30, top: 40),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              User? user = _auth.currentUser;

                              if (user != null) {
                                // Get the user's current credentials for reauthentication
                                AuthCredential credential =
                                    EmailAuthProvider.credential(
                                        email: user.email!,
                                        password: password!);

                                try {
                                  // Reauthenticate the user with the provided credentials
                                  await user
                                      .reauthenticateWithCredential(credential);

                                  // User has been successfully reauthenticated, proceed with updates
                                  if (passwordConf == password) {
                                    await user.updatePassword(password!);
                                  }
                                  if (email != null) {
                                    await user.updateEmail(email!);
                                  }
                                  if (name != null) {
                                    await user.updateDisplayName(name);
                                  }
                                } catch (e) {
                                  throw Exception(
                                      'Reauthentication failed. Please log in again before retrying this request.');
                                }
                              } else {
                                throw Exception('User not found.');
                              }

                              showSnackBar(context, 'Sucssfuly');
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                showSnackBar(
                                  context,
                                  'No user found for that email.',
                                );
                              } else if (e.code == 'wrong-password') {
                                showSnackBar(
                                  context,
                                  'Wrong password provided for that user.',
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            }
                            formKey.currentState!.save();
                          } else {}
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            MyTheme.themeColor,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          elevation: MaterialStateProperty.all<double>(2),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
