import 'package:flutter/material.dart';
import 'package:flutter_supa/auth/auth_gate.dart';
import 'package:flutter_supa/core/routing/routes.dart';
import 'package:flutter_supa/features/home/ui/home_screen.dart';
import 'package:flutter_supa/features/login/ui/login_screen.dart';
import 'package:flutter_supa/features/onboarding/onboarding_screen.dart';
import 'package:flutter_supa/features/sign_up/ui/sign_up_screen.dart';
import 'package:flutter_supa/features/table/table_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => OnBoardingScreen(),
        );

        case Routes.authGate: // إضافة AuthGate كصفحة رئيسية
        return MaterialPageRoute(
          builder: (_) => const AuthGate(),
        );
        
        case Routes.tableScreen: 
        return MaterialPageRoute(
          builder: (_) => const TableScreen(),
        );
        
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) =>  LoginScreen(),
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) =>  SignUpScreen(),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) =>  HomeScreen(),
        );
      default:
        return null;
    }
  }
}