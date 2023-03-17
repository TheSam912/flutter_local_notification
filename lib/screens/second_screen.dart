import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({required this.payload});

  final String payload;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(payload),
      ),
    );
  }
}
