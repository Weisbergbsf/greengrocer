import 'package:get/route_manager.dart';
import 'package:greengrocer/src/pages/auth/sign_in_screen.dart';
import 'package:greengrocer/src/pages/auth/sign_up_screen.dart';
import 'package:greengrocer/src/pages/base/base_screen.dart';
import 'package:greengrocer/src/pages/splash/splash_screen.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(name: PagesRoutes.splashRoute, page: () => const SplashScreen()),
    GetPage(name: PagesRoutes.baseRoute, page: () => const BaseScreen()),
    GetPage(name: PagesRoutes.signInRoute, page: () => const SignInScreen()),
    GetPage(name: PagesRoutes.signUpRoute, page: () => SignUpScreen()),
  ];
}

abstract class PagesRoutes {
  static const String splashRoute = '/splash';
  static const String baseRoute = '/';
  static const String signInRoute = '/signin';
  static const String signUpRoute = '/signup';
}
