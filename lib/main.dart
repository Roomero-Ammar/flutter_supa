import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supa/core/routing/app_router.dart';
import 'package:flutter_supa/flutter_supa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // To fix texts being hidden bug in flutter_screenutil in release mode.
  await ScreenUtil.ensureScreenSize();
  runApp(FlutterSupa(
    appRouter: AppRouter(),
  ));
}

