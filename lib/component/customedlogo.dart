import 'package:flutter/material.dart';

class Customedlogo extends StatelessWidget {
  final String name;
  const Customedlogo({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(10),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(80),
          ),
          child: Image.asset(name, width: 50, height: 50),
        ),
      ],
    );
  }
}


