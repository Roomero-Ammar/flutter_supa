import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supa/service_locator/auth_service.dart';
import 'package:flutter_supa/core/helpers/spacing.dart';
import 'package:flutter_supa/core/routing/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theming/styles.dart';
import '../../../core/widgets/app_text_button.dart';
import 'widgets/dont_have_account_text.dart';
import 'widgets/email_and_password.dart';
import 'widgets/terms_and_conditions.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 30.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome Back', style: TextStyles.font24BlueBold),
                verticalSpace(8),
                Text(
                  "We're excited to have you back, can't wait to see what you've been up to.",
                  style: TextStyles.font14GrayRegular,
                ),
                verticalSpace(35),
                Column(
                  children: [
                    EmailAndPassword(
                      formKey: formKey,
                      emailController: emailController,
                      passwordController: passwordController,
                    ),
                    verticalSpace(40),
                    AppTextButton(
                      buttonText: "Login",
                      textStyle: TextStyles.font16WhiteSemiBold,
                      onPressed: () {
                        validateThenLogin(context);
                      },
                    ),
                    verticalSpace(20),
                    const Text(
                      "Or continue with",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    verticalSpace(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialLoginButton(
                          icon: FontAwesomeIcons.google, // Google Icon
                          color: Colors.red,
                          onTap: () => _authService.signInWithOAuth(OAuthProvider.google),
                        ),
                        horizontalSpace(20),
                        _buildSocialLoginButton(
                          icon: FontAwesomeIcons.facebookF,  // Facebook Icon
                          color: Colors.blue,
                          onTap: () => _authService.signInWithOAuth(OAuthProvider.facebook),
                        ),
                        horizontalSpace(20),
                        _buildSocialLoginButton(
                          icon: FontAwesomeIcons.github, // GitHub Icon
                          color: Colors.black,
                          onTap: () => _authService.signInWithOAuth(OAuthProvider.github),
                        ),
                      ],
                    ),
                    verticalSpace(15),
                    const TermsAndConditionsText(),
                    verticalSpace(30),
                    const DontHaveAccountText(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> validateThenLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        final response = await _authService.signIn(
          email: emailController.text,
          password: passwordController.text,
        );

        if (response?.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Login successful!")),
          );
          Navigator.of(context).pushNamed(Routes.homeScreen);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error: ${e.toString()}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Please fill all fields correctly.")),
      );
    }
  }

  /// تسجيل الدخول باستخدام OAuth لخدمات مثل Google و Facebook و GitHub
 Future<void> signInWithOAuth(OAuthProvider provider) async {
  try {
    await _supabase.auth.signInWithOAuth(provider);
    print("✅ Redirecting to provider: $provider");

    // انتظر حتى يتم تحديث المستخدم بعد المصادقة
    await Future.delayed(Duration(seconds: 3));

    final user = _supabase.auth.currentUser;
    if (user != null) {
      print("✅ OAuth login successful! User ID: ${user.id}");
    } else {
      print("❌ OAuth login failed!");
    }
  } on AuthException catch (e) {
    throw Exception(e.message);
  }
}
 /// زر تسجيل الدخول عبر الشبكات الاجتماعية
  Widget _buildSocialLoginButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: color,
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
