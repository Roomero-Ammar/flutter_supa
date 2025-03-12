import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supa/core/helpers/extentsions.dart';
import 'package:flutter_supa/core/helpers/spacing.dart';
import 'package:flutter_supa/core/routing/routes.dart';
import '../../../core/theming/styles.dart';
import '../../../core/widgets/app_text_button.dart';
import 'widgets/dont_have_account_text.dart';
import 'widgets/email_and_password.dart';
import 'widgets/terms_and_conditions.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); // ✅ مفتاح النموذج
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                Text('Welcome Back', style: TextStyles.font24BlueBold),
                verticalSpace(8),
                Text(
                  'We\'re excited to have you back, can\'t wait to see what you\'ve been up to since you last logged in.',
                  style: TextStyles.font14GrayRegular,
                ),
                verticalSpace(36),
                EmailAndPassword(
                  formKey: formKey, // ✅ تمرير مفتاح النموذج
                  emailController: emailController, // ✅ تمرير الكونترولر
                  passwordController: passwordController, // ✅ تمرير الكونترولر
                ),
                verticalSpace(24),
          Row(
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Safety',
            style: TextStyles.font13DarkBlueMedium,
          ),
          Divider(), // خط فاصل تحت العنوان
          Text(
            'At least 1 lowercase letter',
            style: TextStyles.font11BlackBold,
          ),
          verticalSpace(2),
          Text(
            'At least 1 uppercase letter',
            style: TextStyles.font11BlackBold,
          ),
          verticalSpace(2),
          Text(
            'At least 1 special character',
            style: TextStyles.font11BlackBold,
          ),
          verticalSpace(2),
          Text(
            'At least 1 number',
            style: TextStyles.font11BlackBold,
          ),
          verticalSpace(2),
          Text(
            'At least 8 characters long',
            style: TextStyles.font11BlackBold,
          ),
        ],
      ),
    ),
    VerticalDivider(
      width: 20, // عرض الخط الفاصل
      thickness: 1, // سمك الخط الفاصل
      color: Colors.grey, // لون الخط الفاصل
    ),
    horizontalSpace(10), // فراغ أفقي
    Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Email Requirements',
        style: TextStyles.font13DarkBlueMedium,
      ),
      Divider(), // خط فاصل تحت العنوان
      Text(
        'Must contain an "@" symbol',
        style: TextStyles.font11BlackBold,
      ),
      verticalSpace(2),
     
      Text(
        'Must end with (.com)',
        style: TextStyles.font11BlackBold,
      ),
      verticalSpace(2),
      Text(
        'No spaces allowed',
        style: TextStyles.font11BlackBold,
      ),
     verticalSpace(2),
      Text(
        '',
        style: TextStyles.font11BlackBold,
      ),
      verticalSpace(2),
      Text(
        '',
        style: TextStyles.font11BlackBold,
      ),
    ],
  ),
),
  ],
),      verticalSpace(24),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyles.font13BlueRegular,
                  ),
                ),
                verticalSpace(40),
                AppTextButton(
                  buttonText: "Login",
                  textStyle: TextStyles.font16WhiteSemiBold,
                  buttonHeight: 55,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // ✅ إذا كانت البيانات صحيحة
                      print("✅ البريد الإلكتروني: ${emailController.text}");
                      print("✅ كلمة المرور: ${passwordController.text}");
                      context.pushNamed(Routes.signUpScreen);
                    } else {
                      // ❌ إذا كانت هناك حقول فارغة
                      print("❌ يجب ملء جميع الحقول!");
                    }
                  },
                ),
                verticalSpace(16),
                const TermsAndConditionsText(),
                verticalSpace(60),
                const DontHaveAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
