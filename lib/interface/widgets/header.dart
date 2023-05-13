import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/fade_slide_transition.dart';
import '../../core/utils/my_theme.dart';

class Header extends StatelessWidget {
  final Animation<double> animation;
  final bool isLogin;
  final String welcome;

  const Header({
    Key? key,
    required this.welcome,
    required this.animation,
    required this.isLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 50),
          Card(
            clipBehavior: Clip.antiAlias,
            color: MyTheme.themeColorFive,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 10,
            shadowColor: MyTheme.themeColorFive,
            child: Image.asset(
              'assets/images/logo.png',
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: kSpaceM),
          FadeSlideTransition(
            animation: animation,
            additionalOffset: 0.0,
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  welcome,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  ' SciSpaceX',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: MyTheme.themeColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            )),
          ),
          const SizedBox(height: kSpaceS),
        ],
      ),
    );
  }
}
