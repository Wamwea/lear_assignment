import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lear_assignment/core/presentation/screens/splash_screen.dart';
import 'package:lear_assignment/features/authentication/logic/auth_provider.dart';

import '../presentation/screens/home_page.dart';
import '../../features/authentication/presentation/screens/auth_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final container = ProviderContainer();

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: AuthRoute.page, path: '/auth'),
        AutoRoute(
          path: '/',
          page: SplashRoute.page,
          initial: true,
        ),
      ];
}
