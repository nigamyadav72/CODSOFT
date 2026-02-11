import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Center(child: Text('hello world')),
          Image.asset('image.jpg'),
        ],
      ),
    );
  }
}
