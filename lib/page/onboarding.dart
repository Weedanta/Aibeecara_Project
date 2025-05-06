import 'package:flutter/material.dart';
import 'package:my_project/page/home.dart';
import 'package:my_project/themes/color.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.white,
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset("images/logo.png")]),
            const SizedBox(
              height: 72,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorStyle.color06),
                child: Text("Let's Get Started",
                    style: TextStyle(
                      fontSize: 20,
                      color: ColorStyle.white,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
