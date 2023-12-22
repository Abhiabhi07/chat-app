import 'package:flutter/material.dart';

void showErrorBtmSheet(BuildContext context, String error) {
  showBottomSheet(
    context: context,
    builder: (context) => ErrorScreen(
      error: error,
    ),
  );
}

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Text(
            error,
            style: Theme.of(context).textTheme.titleMedium,
          );
        });
  }
}
