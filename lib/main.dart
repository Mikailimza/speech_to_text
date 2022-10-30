import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sound_to_text/staticParams/ruoter_genarators.dart';
import 'staticParams/translations.dart';


//Mikail imza - 30.10.20.22 ---- mikailimza@gmail.com
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('mesaj');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: getPages.page,
      translations: Language(),
      locale: const Locale('tr', 'TR'),
      fallbackLocale: const Locale('en', 'US'),
      title: 'titles'.tr,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Montserrat'),
    );
  }
}
