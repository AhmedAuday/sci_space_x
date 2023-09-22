// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sci_space_x/interface/Theme/themes.dart';
import 'package:sci_space_x/interface/screens/register_screen.dart';
import 'package:sci_space_x/interface/screens/user_page.dart';
import 'package:sci_space_x/interface/widgets/custom_text_filedd.dart';
import '../../core/constants/constants.dart';
import '../../core/custom_clippers/custom_clipping.dart';
import '../../core/helper/show_snakbar.dart';
import '../../core/utils/authentication.dart';
import '../../core/utils/fade_slide_transition.dart';
import '../../core/utils/my_styles.dart';
import '../../core/utils/my_theme.dart';
import '../../core/utils/validators.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/header.dart';
import '../widgets/mybutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String id = "loginScreen";
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  String? email, password, Fname, Lname;
  AnimationController? _animationController;
  Animation<double>? _headerTextAnimation;
  Animation<double>? _formElementAnimation;
  bool obs = false;
  GlobalKey<FormState> formKey = GlobalKey();
  bool formValidate = false;

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();

  bool passwordVisible = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: kLoginAnimationDuration,
    );
  }

  String? formVal(data) {
    if (data!.isEmpty) {
      return 'Field is required';
    }
    return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var fadeSlideTween = Tween<double>(begin: 0.0, end: 1.0);
    _headerTextAnimation = fadeSlideTween.animate(CurvedAnimation(
      parent: _animationController!,
      curve: const Interval(
        0.0,
        0.6,
        curve: Curves.easeInOut,
      ),
    ));
    _formElementAnimation = fadeSlideTween.animate(CurvedAnimation(
      parent: _animationController!,
      curve: const Interval(
        0.7,
        1.0,
        curve: Curves.easeInOut,
      ),
    ));

    _animationController!.forward();
  }

  @override
  void dispose() {
    // _animationController!.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kWhite,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        color: MyTheme.themeColor,
                      ),
                    ),
                    Header(
                      welcome: 'Welcome To',
                      animation: _headerTextAnimation!,
                      isLogin: true,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: FadeSlideTransition(
                    animation: _formElementAnimation!,
                    additionalOffset: 0.0,
                    child: CustomFormTextField(
                      hintText: "Email",
                      prifix: const Icon(
                        Icons.person,
                        color: Colors.black45,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      focusNode: focusEmail,
                      onChanged: (data) async {
                        email = data;
                      },
                      fieldValidator: emailValidator,
                      controller: controllerEmail,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: FadeSlideTransition(
                    animation: _formElementAnimation!,
                    additionalOffset: 10,
                    child: CustomFormTextField(
                      hintText: "Password",
                      prifix: const Icon(
                        Icons.lock,
                        color: Colors.black45,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      focusNode: focusPassword,
                      onChanged: (data) {
                        password = data;
                      },
                      controller: controllerPassword,
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
                      fieldValidator: fieldValidator,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: FadeSlideTransition(
                    animation: _formElementAnimation!,
                    additionalOffset: 2 * 10.0,
                    child: InkWell(
                      onTap: () {
                        // Navigator.pushNamed(context, RegisterScreen.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Forgot Password?", style: forgotPasswordStyle),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: FadeSlideTransition(
                    animation: _formElementAnimation!,
                    additionalOffset: 2 * 10.0,
                    child: CustomButton(
                      color: MyTheme.themeColor,
                      textColor: kWhite,
                      text: 'Login',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            User userCredential = await loginUser();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => UserInfoScreen(
                                  user: userCredential,
                                ),
                              ),
                            );
                            showSnackBar(context, 'Sucssfuly');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              showSnackBar(
                                  context, 'No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              showSnackBar(context,
                                  'Wrong password provided for that user.');
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
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: 2 * 10.0,
                  child: SizedBox(
                    child: Text(
                      "OR",
                      style: MyThemeData.of(context).title1,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: 2 * 10.0,
                  child: FutureBuilder(
                    future: Authentication.initializeFirebase(context: context),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Error initializing Firebase');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return const GoogleSignInButton();
                      }
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColors.firebaseOrange,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 2 * 60.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                  child: FadeSlideTransition(
                    animation: _formElementAnimation!,
                    additionalOffset: 2 * 10.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterScreen.id);
                      },
                      child: Row(
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: MyThemeData.of(context).subtitle2,
                          ),
                          const SizedBox(width: 3),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Sign Up",
                              style: MyThemeData.of(context).subtitle4,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<User> loginUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    return user.user!;
  }

  fieldFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
