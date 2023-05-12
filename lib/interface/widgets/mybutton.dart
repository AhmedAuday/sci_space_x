import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.onPressed,
    // ignore: unnecessary_null_comparison
  })  : assert(textColor != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: color,
          backgroundColor: color,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: textColor, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
