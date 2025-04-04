import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supa/core/helpers/extentsions.dart';
import 'package:flutter_supa/core/routing/routes.dart';


import '../../../../core/theming/styles.dart';

class DontHaveAccountText extends StatelessWidget {
  const DontHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account?',
              style: TextStyles.font13GrayRegular,
            ),
            TextSpan(
              text: ' Sign Up',
              style: TextStyles.font13BlueSemiBold,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  context.pushReplacementNamed(Routes.signUpScreen);
                },
            ),
          ],
        ),
      ),
    );
  }
}

