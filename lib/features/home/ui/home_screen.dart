import 'package:flutter/material.dart';
import 'package:flutter_supa/auth/auth_service.dart';
import 'package:flutter_supa/core/helpers/extentsions.dart';
import 'package:flutter_supa/core/routing/routes.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            //  Navigator.of(context).pushNamed(Routes.loginScreen);
              context.pushNamed(Routes.loginScreen);
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Welcome to the Home Screen!"),
      ),
    );
  }
}