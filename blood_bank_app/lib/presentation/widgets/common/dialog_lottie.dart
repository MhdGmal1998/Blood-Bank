import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class MyLottie extends StatefulWidget {
  const MyLottie({super.key});

  @override
  State<MyLottie> createState() => _MyLottieState();
}

class _MyLottieState extends State<MyLottie> with TickerProviderStateMixin {
  // late AnimationController _controller;
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(vsync: this);
  //   _controller.addListener(() {
  //     print(_controller.value);
  //     if (_controller.value > 0.5) {
  //       _controller.value = 0.5;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
      child: Lottie.asset(
        'assets/blood-donation.json',
        repeat: true,
        reverse: true,
        animate: true,
      ),
    ));
  }
}
