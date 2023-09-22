import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/my_theme.dart';
import '../Theme/themes.dart';

class HeaderE extends StatelessWidget {
  final Animation<double>? animation;
  final bool isLogin;
  final String welcome;
  final String img;

  const HeaderE({
    Key? key,
    required this.img,
    required this.welcome,
    this.animation,
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
              side: BorderSide(
                color: MyThemeData.of(context).primaryBackground!,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 10,
            shadowColor: MyTheme.themeColorFive,
            child: Image.network(
              img,
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: kSpaceM),
          Center(
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
              ],
            ),
          ),
          const SizedBox(height: kSpaceS),
        ],
      ),
    );
  }
}
