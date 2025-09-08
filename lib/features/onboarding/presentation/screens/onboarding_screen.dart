import 'package:flutter/material.dart';
import '../../../auth/presentation/screens/sign_in_screen.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/splash_widget.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              SplashWidget(), // Ensure this widget is defined in splash_widget.dart
              OnboardingPageWidget(
                icon: Icons.stop,
                title: 'Best online courses in the world',
                description:
                'Now you can learn anywhere, anytime, even if there is no internet access!',
                onButtonPressed: () {
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                buttonText: 'Next',
              ),
              OnboardingPageWidget(
                icon: Icons.school,
                title: 'Explore your new skill today',
                description:
                'Our platform is designed to help you explore new skills. Let\'s learn & grow with Eduline!',
                onButtonPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                buttonText: 'Get Started',
              ),
            ],
          ),
          if (_currentPage > 0 && _currentPage < 2)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index + 1 ? Colors.blue : Colors.grey,
                  ),
                )),
              ),
            ),
        ],
      ),
    );
  }
}