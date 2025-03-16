import 'package:flutter/material.dart';
import 'package:flutter_supa/auth/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final userData = _authService.getCurrentUserData();
    final userSelectedData = _authService.getSelectedCurrentUserData(
fields: ["ID", "Email", "Created At" ]  //// 🔹 اختر الحقول التي تريد عرضها فقط

    );

    final user = _authService.getCurrentUser();
    final userEmail = _authService.getCurrentUserEmail();
    final isSignedIn = _authService.isUserSignedIn();

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            /// ✅ عرض بيانات `getCurrentUserData()`
            if (userData != null) ...userData.entries.map((entry) {
              return Card(
                color: Colors.black,
                child: ListTile(
                  title: Text(entry.key,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.yellow)),
                  subtitle: Text(entry.value.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              );
            }).toList(),

            /// ✅ عرض بيانات `getSelectedCurrentUserData()`
            //
            //
          //  if (userSelectedData.isNotEmpty)
              Card(
    color: Colors.deepPurpleAccent,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: userSelectedData.split("\n").map((line) {
          final parts = line.split(": ");
          final title = parts.first;
          final value = parts.length > 1 ? parts[1] : "Not Available";

          return ListTile(
            title: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.yellow)),
            subtitle: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          );
        }).toList(),
      ),
    ),
  ),

  //
  //

            /// ✅ عرض بيانات `getCurrentUser()`
            Card(
              color: Colors.amber,
              child: ListTile(
                title: const Text("User ID",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                subtitle: Text(user?.id ?? "Not Available",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),

            /// ✅ عرض بيانات `getCurrentUserEmail()`
            Card(
              color: Colors.white,
              child: ListTile(
                title: const Text("User Email",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                subtitle: Text(userEmail ?? "Not Available",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),

            /// ✅ عرض حالة تسجيل الدخول `isUserSignedIn()`
            Card(
              color: Colors.blue,
              child: ListTile(
                title: const Text("Signed In",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                subtitle: Text(isSignedIn ? "Yes" : "No",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
