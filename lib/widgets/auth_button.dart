import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.child,
    required this.onPressed,
  });
  final Widget child;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 0.0,
            minimumSize: const Size(double.infinity, 55.0),
            backgroundColor: Colors.green,
            side: BorderSide(color: Colors.teal)),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
