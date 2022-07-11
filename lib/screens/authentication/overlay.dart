import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OverLayScreen extends StatefulWidget {
  const OverLayScreen({Key? key}) : super(key: key);

  @override
  _OverLayScreenState createState() => _OverLayScreenState();
}

class _OverLayScreenState extends State<OverLayScreen> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Lottie.asset(
          'assets/lottie/loading.json',
          width: _size.width * 0.2,
          height: _size.height * 0.2,
        ),
      ),
    );
  }
}
