import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supa/service_locator/auth_service.dart';
import 'package:flutter_supa/core/helpers/spacing.dart';
import 'package:flutter_supa/core/routing/routes.dart';
import 'package:flutter_supa/core/theming/styles.dart';
import 'package:flutter_supa/core/widgets/app_text_button.dart';
import '../../login/ui/widgets/terms_and_conditions.dart';
import 'widgets/already_have_account.dart';
import 'widgets/signup_form.dart';


class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: TextStyles.font24BlueBold,
                ),
                verticalSpace(8),
                Text(
                  'Sign up now and start exploring all that our app has to offer. We\'re excited to welcome you to our community!',
                  style: TextStyles.font14GrayRegular,
                ),
                verticalSpace(36),
                Column(
                  children: [
                    SignupForm(
                      formKey: formKey,
                      nameController: nameController,
                      emailController: emailController,
                      passwordController: passwordController,
                    ),
                    verticalSpace(40),
                    AppTextButton(
                      buttonText: "Create Account",
                      textStyle: TextStyles.font16WhiteSemiBold,
                      onPressed: () {
                        validateThenSignup(context);
                      },
                    ),
                    verticalSpace(16),
                    const TermsAndConditionsText(),
                    verticalSpace(30),
                    const AlreadyHaveAccountText(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> validateThenSignup(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        final response = await _authService.signUp(
          email: emailController.text,
          password: passwordController.text,
        );

        if (response?.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Sign-up successful! Check your email.")),
          );
          Navigator.of(context).pushNamed(Routes.loginScreen);
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
}