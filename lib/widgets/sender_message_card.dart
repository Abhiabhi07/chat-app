import 'package:flutter/material.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.userName,
  }) : super(key: key);
  final String message;
  final String date;
  final String userName;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(15.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dismissible(
          key: const Key('dismiss'),
          background: Container(
            // width: 20,
            padding: const EdgeInsets.only(right: 10.0),
            alignment: Alignment.centerRight,
            child: Text(
              date,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
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
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // alignment: Alignment.bottomLeft,
                  margin: const EdgeInsets.only(
                    left: 2,
                  ),
                  height: 20,
                  // padding: const EdgeInsets.all(10.0),

                  width: 4.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black),
                ),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
