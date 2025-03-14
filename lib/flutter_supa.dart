import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supa/core/routing/app_router.dart';
import 'package:flutter_supa/core/theming/theme_provider.dart';
import 'package:provider/provider.dart';

import 'core/routing/routes.dart';

class FlutterSupa extends StatelessWidget {
  final AppRouter appRouter;
  const FlutterSupa({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // ✅ تسجيل `ThemeProvider` هنا
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              title: 'Flutter Supa',
              themeMode: themeProvider.themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              debugShowCheckedModeBanner: false,
              initialRoute: Routes.authGate,
              onGenerateRoute: appRouter.generateRoute,
            );
          },
        ),
      ),
    );
  }
}
