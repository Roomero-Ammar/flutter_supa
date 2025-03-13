import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supa/auth/auth_service.dart';
import 'package:flutter_supa/core/helpers/spacing.dart';
import 'package:flutter_supa/core/routing/routes.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 30.h, vertical: 30.w),
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
Navigator.of(context).pushNamed(Routes.homeScreen);        }
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
}