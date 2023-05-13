// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sci_space_x/interface/screens/login_screen.dart';
import 'package:sci_space_x/interface/widgets/custom_text_filedd.dart';

import '../../core/constants/constants.dart';
import '../../core/custom_clippers/custom_clipping.dart';
import '../../core/helper/show_snakbar.dart';
import '../../core/utils/fade_slide_transition.dart';
import '../../core/utils/my_theme.dart';
import '../../core/utils/validators.dart';
import '../Theme/themes.dart';
import '../widgets/header.dart';
import '../widgets/mybutton.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static String id = "registerScreen";

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  String? email, password;
  AnimationController? _animationController;
  Animation<double>? _headerTextAnimation;
  Animation<double>? _formElementAnimation;
  bool obs = false;
  GlobalKey<FormState> formKey = GlobalKey();
  bool formValidate = false;

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerFname = TextEditingController();
  TextEditingController controllerLname = TextEditingController();
  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();
  FocusNode focusFName = FocusNode();
  FocusNode focusLname = FocusNode();

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
                      welcome: 'Create New Account',
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
                      hintText: "First Name",
                      prifix: const Icon(
                        Icons.person_2_rounded,
                        color: Colors.black45,
                      ),
                      keyboardType: TextInputType.name,
                      focusNode: focusFName,
                      onChanged: (data) async {},
                      fieldValidator: fieldValidator,
                      controller: controllerFname,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: FadeSlideTransition(
                    animation: _formElementAnimation!,
                    additionalOffset: 0.0,
                    child: CustomFormTextField(
                      hintText: "Last Name",
                      prifix: const Icon(
                        Icons.person_2_outlined,
                        color: Colors.black45,
                      ),
                      keyboardType: TextInputType.name,
                      focusNode: focusLname,
                      onChanged: (data) async {},
                      fieldValidator: fieldValidator,
                      controller: controllerLname,
                    ),
                  ),
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: FadeSlideTransition(
                    animation: _formElementAnimation!,
                    additionalOffset: 2 * 10.0,
                    child: CustomButton(
                      color: MyTheme.themeColor,
                      textColor: kWhite,
                      text: 'Register',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            await registerUser();

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
                const SizedBox(height: 2 * 60.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(90, 0, 70, 0),
                  child: FadeSlideTransition(
                    animation: _formElementAnimation!,
                    additionalOffset: 2 * 10.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: Row(
                        children: [
                          Text(
                            "have an account? ",
                            style: MyThemeData.of(context).subtitle2,
                          ),
                          const SizedBox(width: 3),
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushReplacement(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return const Register();
                              // }));
                            },
                            child: Text(
                              "Sign in",
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

  Future<void> registerUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email!, password: password!);
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
