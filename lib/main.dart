import 'package:applicatec/Constantes/Config.dart';
import 'package:applicatec/widgets/Login.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/Scaffold.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: Config.mSupabaseUrl,
    anonKey: Config.mSupabaseKey,


  );

  runApp(
    DevicePreview(
      builder: (_)=>const MyApp(),
      enabled: !kReleaseMode,
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      home: Login(),
      debugShowCheckedModeBanner: false
    );
  }
}