import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة Hive للحفظ المحلي
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('adhkar');
  await Hive.openBox('custom');
  await Hive.openBox('notes');
  
  // قفل الاتجاه عمودي
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // شريط الحالة شفاف
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  
  runApp(const NourElQalbApp());
}
