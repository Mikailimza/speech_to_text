// ignore_for_file: unused_import

import 'package:get/get.dart';
import 'package:sound_to_text/pages/home.dart';
//Mikail imza - 30.10.20.22 ---- mikailimza@gmail.com 
mixin getPages {
  static List<GetPage<dynamic>>? page = [
    GetPage(
      name: '/',
      page: () => const MyHomePage(),
    ),

    /* GetPage(
        name: '/nointernet',
        page: () => const NoInternet(),
        transition: Transition.zoom), */
  ];
}
