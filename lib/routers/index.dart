import 'package:get/get.dart';

import '/pages/home/index.dart';
import '/pages/splash/index.dart';

final getPages = [
  GetPage(
    name: "/splash",
    page: () => const SplashPage(),
    binding: SplashBindings(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: "/home",
    page: () => const HomePage(),
    binding: HomeBindings(),
    transition: Transition.fadeIn,
  ),
];
