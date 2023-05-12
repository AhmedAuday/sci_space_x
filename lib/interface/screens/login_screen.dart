// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  String? email, password;
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

                        // fieldFocusChange(
                        //   context,
                        //   focusEmail,
                        //   focusPassword,
                        // );
                      },
                      fieldValidator: fieldValidator,
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
                      onTap: () {},
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
                            await loginUser();

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
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: FadeSlideTransition(
                    animation: _formElementAnimation!,
                    additionalOffset: 2 * 10.0,
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Text(
                            "Don't have an account?",
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushReplacement(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return const Register();
                              // }));
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2 * 10.0),
                FutureBuilder(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
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
