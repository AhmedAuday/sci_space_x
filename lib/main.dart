import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sci_space_x/core/providers/models_provider.dart';
import 'package:sci_space_x/interface/screens/login_screen.dart';

import 'core/constants/constants.dart';
import 'core/providers/chats_provider.dart';
import 'interface/Theme/themes.dart';
import 'interface/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MyThemeData.initialize();
  runApp(const SciSpaceX());
}

class SciSpaceX extends StatefulWidget {
  const SciSpaceX({super.key});
  // ignore: library_private_types_in_public_api
  static _SciSpaceXState? of(BuildContext context) =>
      context.findAncestorStateOfType<_SciSpaceXState>();
  @override
  State<SciSpaceX> createState() => _SciSpaceXState();
}

class _SciSpaceXState extends State<SciSpaceX> {
  final ThemeMode _themeMode = MyThemeData.themeMode;
  void setThemeMode(ThemeMode mode) => setState(() {
        //_themeMode = mode;
        MyThemeData.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'SciSpaceX',
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: _themeMode,
        // theme: ThemeData(brightness: Brightness.light),
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
            color: cardColor,
          ),
        ),
        routes: {
          HomePage.id: (context) => const HomePage(),
        },
        home: const LoginView(),
      ),
    );
  }
}
