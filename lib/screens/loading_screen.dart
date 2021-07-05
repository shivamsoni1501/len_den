import 'package:flutter/material.dart';

class LodingScreen extends StatelessWidget {
  const LodingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive(),),
    );
  }
}