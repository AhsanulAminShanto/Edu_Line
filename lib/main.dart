// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Optional, with fallback
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'routes/app_routes.dart';
import 'features/onboarding/presentation/widgets/splash_widget.dart';
import 'core/theme/app_theme.dart'; // Ensure this file exists or define inline

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ConnectivityResult? connectivityResult;
  bool hasInternet = true;

  // Attempt to check connectivity (optional, with try-catch to avoid crashes)
  try {
    connectivityResult = await Connectivity().checkConnectivity();
    hasInternet = connectivityResult != ConnectivityResult.none;
  } catch (e) {
    print('⚠️ Connectivity check failed: $e. Assuming internet is available.');
    hasInternet = true; // Fallback to assume connection if check fails
  }

  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }

  runApp(MyApp(hasInternet: hasInternet));
}

class MyApp extends StatelessWidget {
  final bool hasInternet;

  const MyApp({super.key, required this.hasInternet});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theory Test App',
      theme: AppTheme.lightTheme, // Ensure this is defined
      home: SplashScreen(hasInternet: hasInternet),
      routes: AppRoutes.routes,
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => SplashScreen(hasInternet: hasInternet));
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Define a basic theme if not already in core/theme/app_theme.dart
class AppTheme {
  static final lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

class SplashScreen extends StatefulWidget {
  final bool hasInternet;

  const SplashScreen({super.key, required this.hasInternet});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));
    if (widget.hasInternet) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please connect and try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashWidget();
  }
}