import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Sign Up method
  Future<AuthResponse?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Sign In method
  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Sign Out method
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }
  // التحكم فى ظهور قيم محدده
  String getSelectedCurrentUserData({List<String>? fields}) {
  final session = _supabase.auth.currentSession;
  final user = session?.user;

  if (user != null) {
    Map<String, String> data = {
      "ID": user.id,
      "Email": user.email?? "not found",
      "Created At": user.createdAt != null ? DateTime.parse(user.createdAt!).toIso8601String() : "Unknown",
      "User Metadata": user.userMetadata?.toString() ?? "None",
      "Access Token": session?.accessToken ?? "Not Available",
      "Refresh Token": session?.refreshToken ?? "Not Available",
      "Expires At": session?.expiresAt?.toString() ?? "Not Available",
    };

    // 🔹 إذا لم يتم تحديد الحقول، نعيد كل البيانات
    if (fields == null) {
      return data.entries.map((e) => "${e.key}: ${e.value}").join("\n");
    }

    // 🔹 تصفية البيانات وإعادة فقط القيم المطلوبة
    return fields.map((key) => "$key: ${data[key] ?? 'Not Available'}").join("\n");
  }

  return "No user logged in";
}


  /// Get current user
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
  
// get current user email
String? getCurrentUserEmail(){
final session = _supabase.auth.currentSession;
final user = session?.user;
return user?.email;
}

  /// Check if user is signed in
  bool isUserSignedIn() {
    return _supabase.auth.currentSession != null;
  }

  // all data of current user
    /// 🔹 استرجاع جميع بيانات المستخدم الحالي
  Map<String, dynamic>? getCurrentUserData() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;

    if (user != null) {
      return {
        "ID": user.id,
        "Email": user.email,
      "Created At": user.createdAt != null ? DateTime.parse(user.createdAt!).toIso8601String() : "Unknown",
        "User Metadata": user.userMetadata, // بيانات مثل الاسم ورقم الهاتف
        "Access Token": session?.accessToken,
        "Refresh Token": session?.refreshToken,
        "Expires At": session?.expiresAt,
      };
    }
    return null;
  }
}
