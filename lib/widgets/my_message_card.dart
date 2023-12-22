import 'package:flutter/material.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final String userName;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.userName,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(15.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Dismissible(
          key: const Key('dismiss'),
          background: Container(
            // width: 20,
            padding: const EdgeInsets.only(right: 10.0),
            alignment: Alignment.centerRight,
            // decoration: BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  date,
                  // textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          onDismissed: (direction) {},
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45,
            ),
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.orangeAccent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 7),
                  height: 25,
                  width: 4.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: isSeen ? Colors.blue : Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
