import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/functions.dart';
import 'package:shop_app/core/cache_helper.dart';
import 'package:shop_app/login/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel(
      {@required this.image, @required this.title, @required this.body});
}

List<BoardingModel> boarding = [
  BoardingModel(
      image: 'assets/images/two.jpg',
      title: 'Online Shopping',
      body: 'You can shop anything, anytime, anywhere that you want'),
  BoardingModel(
      image: 'assets/images/three.jpg',
      title: 'Fast Delivery',
      body: 'Your product will be delivered to your address'),
  BoardingModel(
      image: 'assets/images/one.jpg',
      title: 'Hot Offers',
      body: 'Get the discount and choose the payment method'),
];

var boardController = PageController();

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {
                submit();
              },
              child: const Text(
                'SKIP',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, bottom: 20.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: PageView.builder(
              controller: boardController,
              onPageChanged: (int index) {
                if (index == boarding.length - 1) {
                  setState(() {
                    isLast = true;
                  });
                } else {
                  isLast = false;
                }
              },
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  buildBoardingItem(boarding[index]),
              itemCount: boarding.length,
            )),
            const SizedBox(height: 40.0),
            Center(
              child: SmoothPageIndicator(
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.red,
                  dotWidth: 15.0,
                  spacing: 10.0,
                ),
                controller: boardController,
                count: boarding.length,
              ),
            ),
            const SizedBox(height: 10.0),
            FloatingActionButton(
              onPressed: () {
                if (isLast) {
                  submit();
                } else {
                  boardController.nextPage(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.fastLinearToSlowEaseIn);
                }
              },
              child: const Icon(Icons.arrow_forward_ios_sharp),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Image(image: AssetImage(model.image)),
        ),
        const SizedBox(height: 30.0),
        Text(
          model.title,
          style: const TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        Text(
          model.body,
          style: const TextStyle(fontSize: 22.0, color: Colors.black54),
        )
      ],
    );
  }

  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      navigateAndFinish(context, const LoginScreen());
    });
  }
}
