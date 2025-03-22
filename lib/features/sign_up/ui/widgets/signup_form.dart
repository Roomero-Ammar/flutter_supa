import 'package:flutter/material.dart';
import 'package:flutter_supa/core/helpers/spacing.dart';
import '../../../../core/widgets/app_text_form_field.dart';

class SignupForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController; 

  const SignupForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController, 
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
bool isObscureText = true;
bool isObscureText2 = true;


  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          AppTextFormField(
            hintText: 'Full Name',
            controller: widget.nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          verticalSpace(18),
          AppTextFormField(
            hintText: 'Email',
            controller: widget.emailController,
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
            controller: widget.passwordController,
          //  isObscureText: true,
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
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          verticalSpace(18),
          AppTextFormField(
            hintText: 'Confirm Password', 
            controller: widget.confirmPasswordController,
          //  isObscureText: true,
                isObscureText: isObscureText2,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isObscureText2 = !isObscureText2;
                });
              },
              child: Icon(
                isObscureText2 ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != widget.passwordController.text) {
                return 'Passwords is not the same';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
