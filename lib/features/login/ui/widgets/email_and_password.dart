import 'package:flutter/material.dart';
import 'package:flutter_supa/core/helpers/spacing.dart';
import '../../../../core/widgets/app_text_form_field.dart';

class EmailAndPassword extends StatefulWidget {
  final GlobalKey<FormState> formKey; // ✅ استقبال مفتاح النموذج من LoginScreen
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const EmailAndPassword({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey, // ✅ استخدام مفتاح النموذج
      child: Column(
        children: [
          AppTextFormField(
            hintText: 'Email',
            controller: widget.emailController, // ✅ استخدام الكونترولر
            validator: (value) {
             if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          verticalSpace(18),
          AppTextFormField(
            hintText: 'Password',
            controller: widget.passwordController, // ✅ استخدام الكونترولر
            isObscureText: isObscureText,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isObscureText = !isObscureText;
                });
              },
              child: Icon(
                isObscureText ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid password';
              }
              return null;
            },
          ),
          verticalSpace(24),
        ],
      ),
    );
  }
}
