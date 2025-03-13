import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supa/auth/auth_gate.dart';
import 'package:flutter_supa/core/routing/app_router.dart';

import 'core/routing/routes.dart';

class FlutterSupa extends StatelessWidget {
  final AppRouter appRouter;
  const FlutterSupa({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: MaterialApp(
          title: 'Flutter Supa',
          theme: ThemeData(
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
          ),
          debugShowCheckedModeBanner: false,
          // home: const AuthGate(),
        initialRoute: Routes.authGate,
          onGenerateRoute: appRouter.generateRoute,
        ));
  }
}