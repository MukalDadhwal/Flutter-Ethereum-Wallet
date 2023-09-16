import 'package:flutter/material.dart';
import 'transaction_model.dart';

class ListWidget extends StatelessWidget {
  final Result data;
  final String address;
  ListWidget({required this.address, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: data.fromAddress == address
          ? Icon(
              Icons.arrow_outward_rounded,
              color: Colors.red.shade400,
              size: 30,
              shadows: [
                Shadow(
                  blurRadius: 5,
                  color: Colors.grey.shade500,
                  offset: Offset(1, 1),
                )
              ],
            )
          : Icon(
              Icons.arrow_downward,
              color: Colors.green.shade400,
              size: 30,
              shadows: [
                Shadow(
                  blurRadius: 5,
                  color: Colors.grey.shade500,
                  offset: Offset(1, 1),
                )
              ],
            ),
      title: Text(
        data.hash!.substring(0, 11) + '...',
        style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
      ),
      trailing: Text(
        (double.parse(data.value!) / 1000000000000000000).toString(),
        style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
      ),
    );
  }
}
