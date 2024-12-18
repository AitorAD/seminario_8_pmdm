import 'package:flutter/material.dart';

class PurpleBox extends StatelessWidget {
  const PurpleBox({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(top: 90, left: 30, child: _Bubble()),
          Positioned(top: -40, right: -30, child: _Bubble()),
          Positioned(bottom: -50, right: -10, child: _Bubble()),
          Positioned(bottom: 120, right: 20, child: _Bubble()),
          Positioned(bottom: -50, left: -20, child: _Bubble()),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() {
    return BoxDecoration(
        gradient: LinearGradient(colors: [
      Color.fromRGBO(63, 63, 156, 1.0),
      Color.fromRGBO(90, 70, 178, 1.0),
    ]));
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}

