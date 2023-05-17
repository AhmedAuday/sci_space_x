// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sci_space_x/core/utils/validators.dart';
// import 'package:sci_space_x/interface/Theme/themes.dart';
// import 'package:sci_space_x/interface/screens/login_screen.dart';

// import '../../core/constants/constants.dart';
// import '../../core/custom_clippers/custom_clipping.dart';

// import '../../core/utils/my_theme.dart';
// import '../widgets/custom_text_filedd.dart';
// import '../widgets/profile_header.dart';

// class CreateAccountGoogle extends StatefulWidget {
//   const CreateAccountGoogle({Key? key, required User user})
//       : _user = user,
//         super(key: key);
//   final User _user;

//   @override
//   _CreateAccountGoogleState createState() => _CreateAccountGoogleState();
// }

// class _CreateAccountGoogleState extends State<CreateAccountGoogle>
//     with TickerProviderStateMixin {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   GlobalKey<FormState> formKey = GlobalKey();
//   late User _user;

//   String ImgLL =
//       "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png";

//   String? email, password, passwordConf, name;
//   AnimationController? _animationController;
//   Animation<double>? _headerTextAnimation;

//   bool obs = false;

//   bool formValidate = false;

//   TextEditingController controllerEmail = TextEditingController();
//   TextEditingController controllerPassword = TextEditingController();
//   TextEditingController controllerName = TextEditingController();
//   TextEditingController controllerPasswordConf = TextEditingController();

//   bool passwordVisible = false;

//   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     _user = widget._user;
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: kLoginAnimationDuration,
//     );
//   }

//   Route rot() {
//     return PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) =>
//           const LoginScreen(),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         var begin = const Offset(-1.0, 0.0);
//         var end = Offset.zero;
//         var curve = Curves.ease;

//         var tween =
//             Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//         return SlideTransition(
//           position: animation.drive(tween),
//           child: child,
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     // _animationController!.dispose();
//     _animationController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         backgroundColor: kWhite,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: MyTheme.themeColor,
//             ),
//             onPressed: () {
//               // Navigator.pop(context);
//               Navigator.of(context).pushReplacement(rot());
//             },
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Form(
//             key: formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Stack(
//                   children: [
//                     ClipPath(
//                       clipper: CustomClipping(),
//                       child: Container(
//                         height: 175,
//                         width: MediaQuery.of(context).size.width,
//                         color: MyThemeData.of(context).tertiaryColor,
//                       ),
//                     ),
//                     HeaderE(
//                       img: _user.photoURL ?? ImgLL,
//                       welcome: 'Rgister Account',
//                       // animation: _headerTextAnimation!,
//                       isLogin: true,
//                     ),
//                     Positioned(
//                       bottom: 30,
//                       right: 120,
//                       child: Container(
//                         height: 40,
//                         width: 40,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             width: 4,
//                             color: Theme.of(context).scaffoldBackgroundColor,
//                           ),
//                           color: Colors.green,
//                         ),
//                         child: const Icon(
//                           Icons.edit,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 35,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                   child: CustomFormTextField(
//                     controller: controllerName,
//                     hintText: _user.displayName,
//                     prifix: const Icon(
//                       Icons.person,
//                       color: Colors.black,
//                     ),
//                     keyboardType: TextInputType.text,
//                     onChanged: (data) {
//                       name = data;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                   child: Text(
//                     _user.email!,
//                     style: MyThemeData.of(context).title1,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                   child: CustomFormTextField(
//                     fieldValidator: fieldValidator,
//                     controller: controllerPassword,
//                     hintText: "Password",
//                     prifix: const Icon(
//                       Icons.password,
//                       color: Colors.black,
//                     ),
//                     keyboardType: TextInputType.text,
//                     onChanged: (data) {
//                       password = data;
//                     },
//                     suffixIcon: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           obs = !obs;
//                           passwordVisible = !passwordVisible;
//                         });
//                       },
//                       icon: passwordVisible
//                           ? const Icon(
//                               Icons.visibility,
//                               color: Colors.black45,
//                             )
//                           : const Icon(
//                               Icons.visibility_off,
//                               color: Colors.black54,
//                             ),
//                     ),
//                     obs: obs,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                   child: CustomFormTextField(
//                     fieldValidator: fieldValidator,
//                     controller: controllerPasswordConf,
//                     hintText: "Password Conformation",
//                     prifix: const Icon(
//                       Icons.lock_outline,
//                       color: Colors.black,
//                     ),
//                     keyboardType: TextInputType.text,
//                     onChanged: (data) {
//                       passwordConf = data;
//                     },
//                     obs: true,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 35,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(right: 30, top: 40),
//                       child: ElevatedButton(
//                         onPressed: () async {}
//                         //   if (formKey.currentState!.validate()) {
//                         //     try {
//                         //       User userCredential = await _updateInfo(
//                         //         photoURL: _user.photoURL!,
//                         //         email: _user.email!,
//                         //         password: password!,
//                         //         fullname:
//                         //             name == null ? _user.displayName! : name!,
//                         //       );
//                         //       Navigator.of(context).pushReplacement(
//                         //         MaterialPageRoute(
//                         //           builder: (context) => UserInfoScreen(
//                         //             user: _user,
//                         //           ),
//                         //         ),
//                         //       );

//                         //       showSnackBar(context, 'Sucssfuly');
//                         //     } on FirebaseAuthException catch (e) {
//                         //       if (e.code == 'user-not-found') {
//                         //         showSnackBar(
//                         //             context, 'No user found for that email.');
//                         //       } else if (e.code == 'wrong-password') {
//                         //         showSnackBar(context,
//                         //             'Wrong password provided for that user.');
//                         //       }
//                         //     } catch (e) {
//                         //       ScaffoldMessenger.of(context).showSnackBar(
//                         //         SnackBar(
//                         //           content: Text(e.toString()),
//                         //         ),
//                         //       );
//                         //     }
//                         //     formKey.currentState!.save();
//                         //   } else {}
//                         ,
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                             MyTheme.themeColor,
//                           ),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           elevation: MaterialStateProperty.all<double>(2),
//                         ),
//                         child: const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 50),
//                           child: Text(
//                             "SAVE",
//                             style: TextStyle(
//                               fontSize: 14,
//                               letterSpacing: 2.2,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Future<User> _updateInfo({
//   //   required String password,
//   //   required String email,
//   //   required String fullname,
//   //   required String photoURL,
//   // }) async {
//   //   var auth = FirebaseAuth.instance;
//   //   AuthCredential credential =
//   //       EmailAuthProvider.credential(email: email, password: password);

//   //   await _user.reauthenticateWithCredential(credential);
//   //   // String fullName = "$Fname $Lname";

//   //   final userP = user.user;
//   //   await userP!.updateDisplayName(fullname);
//   //   await userP.updatePhotoURL(photoURL);
//   //   return _;
//   // }
// }
