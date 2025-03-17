import 'package:flutter/material.dart';
import 'package:flutter_supa/service_locator/auth_service.dart';

class OnBoardingScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final userData = _authService.getCurrentUserData();

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: userData == null
          ? const Center(child: Text("No user logged in"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: userData.entries.map((entry) {
                  return Card(
                    child: ListTile(
                      title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(entry.value.toString()),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
