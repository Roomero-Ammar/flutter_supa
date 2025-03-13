import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supa/core/routing/app_router.dart';
import 'package:flutter_supa/flutter_supa.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  // 🔹 تهيئة Supabase بعد `WidgetsFlutterBinding.ensureInitialized()`
  await Supabase.initialize(
    url: 'https://lqfsncebyqntdecuoitf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxxZnNuY2VieXFudGRlY3VvaXRmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE4MTIzMTgsImV4cCI6MjA1NzM4ODMxOH0.eNtW1smE42BJMnw3spB5_kLQvvhswwiLygrKtpuhlg8',
  );

  await ScreenUtil.ensureScreenSize();

  runApp(FlutterSupa(
    appRouter: AppRouter(),
  ));
}
