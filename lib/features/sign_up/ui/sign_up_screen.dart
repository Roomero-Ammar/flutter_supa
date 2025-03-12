import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supa/core/helpers/spacing.dart';
import 'package:flutter_supa/core/theming/styles.dart';
import 'package:flutter_supa/core/widgets/app_text_button.dart';
import 'package:flutter_supa/features/login/ui/widgets/email_and_password.dart';

import '../../login/ui/widgets/terms_and_conditions.dart';
import 'widgets/already_have_account.dart';


class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  // ✅ إنشاء مفتاح النموذج للتحقق من صحة البيانات
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ✅ إنشاء Controllers للحقول النصية
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.white,
      ),
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
                    EmailAndPassword(
                  formKey: formKey, // ✅ تمرير مفتاح النموذج
                  emailController: emailController, // ✅ تمرير الكونترولر
                  passwordController: passwordController, // ✅ تمرير الكونترولر
                ),
                    
                    // ✅ تمرير المفتاح والـ Controllers إلى الفورم
                    // SignupForm(
                    //   formKey: formKey,
                    //   nameController: nameController,
                    //   emailController: emailController,
                    //   passwordController: passwordController,
                    // ),
                    verticalSpace(40),
                    AppTextButton(
                      buttonText: "Create Account",
                      textStyle: TextStyles.font16WhiteSemiBold,
                      onPressed: (){
                    if (formKey.currentState!.validate()) {
                      // ✅ إذا كانت البيانات صحيحة
                      print("✅ البريد الإلكتروني: ${emailController.text}");
                      print("✅ كلمة المرور: ${passwordController.text}");
                    } else {
                      // ❌ إذا كانت هناك حقول فارغة
                      print("❌ يجب ملء جميع الحقول!");
                    }
                      }
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

  void validateThenSignup() {
    if (formKey.currentState!.validate()) {
      // ✅ إذا كانت البيانات صحيحة، طباعة القيم أو إرسالها إلى الخادم
      print("✅ Name: ${nameController.text}");
      print("✅ Email: ${emailController.text}");
      print("✅ Password: ${passwordController.text}");
    } else {
      print("❌ Please fill all fields correctly.");
    }
  }
}
