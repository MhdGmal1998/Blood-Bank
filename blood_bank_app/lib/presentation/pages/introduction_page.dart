import 'package:blood_bank_app/presentation/resources/constatns.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../domain/entities/page_view_model_data.dart';
import '../widgets/onboarding/page_view_model.dart';
import 'home_page.dart';
import 'setting_page.dart';

class IntroductionPage extends StatelessWidget {
  static const String routeName = "onboarding_page";
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box(dataBoxName);
    return Scaffold(
      appBar: AppBar(),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
        child: IntroductionScreen(
          pages: [
            myPageViewModel(PageViewModelData(
                image: 'assets/images/4.jpg',
                title: 'Title of 1st Page',
                description:
                    'Title of 1stuier qierguqer dshvjKHD JDEC S  gqprugq rgqpru  Page jhdscvjHDC c  SUCY cu cUC ')),
            myPageViewModel(PageViewModelData(
                image: 'assets/images/4.jpg',
                title: 'Title of 1st Page',
                description:
                    'Title of 1stuier qierguqer dshvjKHD JDEC S  gqprugq rgqpru  Page jhdscvjHDC c  SUCY cu cUC ')),
            myPageViewModel(PageViewModelData(
                image: 'assets/images/4.jpg',
                title: 'Title of 1st Page',
                description:
                    'Title of 1stuier qierguqer dshvjKHD JDEC S  gqprugq rgqpru  Page jhdscvjHDC c  SUCY cu cUC ')),
          ],
          onDone: () {
            box.put('introduction', false);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const HomePage();
                },
              ),
            );
          },
          onChange: (value) {},
          onSkip: () {
            // You can also override onSkip callback
            print("++++++++++++++++++++++++");
            print(box.get('introduction'));
            box.put('introduction', false);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const HomePage();
                },
              ),
            );
          },
          showSkipButton: true,
          // showBackButton: true,
          next: const Icon(
            Icons.arrow_forward_outlined,
            size: 32,
          ),
          skip: const Text(
            "skip",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          done: const Text("Done",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          dotsDecorator: DotsDecorator(
              size: const Size.square(10.0),
              activeSize: const Size(20.0, 10.0),
              activeColor: Colors.blue,
              color: Colors.black26,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0))),
        ),
      ),
    );
  }
}
