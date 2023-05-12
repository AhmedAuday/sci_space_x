import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/my_theme.dart';

// ignore: must_be_immutable
class CustomFormTextField extends StatelessWidget {
  String? hintText;
  Function(String)? onChanged;
  Function(String)? fieldValidator;
  FocusNode focusNode;
  TextInputType keyboardType;

  bool? obs;
  TextEditingController controller;
  Widget prifix;
  void Function(String)? onSubmite;
  Widget? suffixIcon;

  CustomFormTextField({
    Key? key,
    this.suffixIcon,
    this.onSubmite,
    required this.prifix,
    required this.keyboardType,
    required this.focusNode,
    this.hintText,
    this.onChanged,
    this.fieldValidator,
    this.obs = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      controller: controller,
      obscureText: obs!,
      focusNode: focusNode,
      validator: (data) {
        if (data!.isEmpty) {
          return 'Field is required';
        }
        return null;
      },
      keyboardType: keyboardType,
      onChanged: onChanged,
      onFieldSubmitted: onSubmite,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(kPaddingM),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: MyTheme.themeColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.12),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green.withOpacity(0.5),
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: kBlack.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: prifix,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
