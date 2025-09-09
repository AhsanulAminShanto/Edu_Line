// lib/routes/app_routes.dart
import 'package:edu_line/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:edu_line/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:edu_line/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:edu_line/features/auth/presentation/screens/language_selection_screen.dart';

class AppRoutes {
  static const String signIn = '/sign_in';
  static const String signUp = '/sign_up';
  static const String forgotPassword = '/forgot_password';
  static const String languageSelection = '/language_selection';

  static final routes = {
    signIn: (context) => SignInScreen(),
    signUp: (context) => SignUpScreen(),
    forgotPassword: (context) => ForgotPasswordScreen(),
    languageSelection: (context) => LanguageSelectionScreen(),
  };
}