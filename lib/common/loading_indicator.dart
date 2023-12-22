import 'package:flutter/material.dart';

// Widget showLoadingIndicator(BuildContext context) {
//   final loading = showBottomSheet(
//     context: context,
//     builder: (context) => LoadingIndicator(),
//   );
//   return loading;
// }

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(14.0),
            child: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'Loading please wait...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          );
        });
  }
}
