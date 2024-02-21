import 'package:flutter/material.dart';
import 'package:valorant/screens/dashboard_screen/dashboard_screen.dart';
import 'package:valorant/services/api.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _startAnimation();
    super.initState();
  }

  bool animate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: animate ? 1 : 0,
                duration: const Duration(milliseconds: 3000),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/splash.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => animate = true);
    await Adsapi.getads().then((value) async {
      await Future.delayed(
        const Duration(milliseconds: 4000),
        () async {
          await Adsapi.loadAppOpenAd(
            value.opena,
          ).whenComplete(() async {
            // await Adsapi.appOpenAd?.show();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoardScreen(
                  api: value,
                ),
              ),
            );
          });
        },
      );
      return value;
    });
  }
}
