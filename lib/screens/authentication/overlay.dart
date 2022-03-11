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
    return Container(
      height: _size.height,
      width: _size.width,
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Lottie.asset('assets/lottie/loading.json'),
      ),
    );
  }
}
