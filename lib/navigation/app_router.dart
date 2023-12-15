import 'package:auto_route/auto_route.dart';
import 'package:social_app/features/main_screen/view/main_screen/main_screen.dart';
import 'package:social_app/features/chat_screen/view/chat_screen.dart';
import 'package:social_app/core/view/global_bloc_provider.dart';
import 'package:social_app/features/auth/view/splash_screen/splash_screen.dart';
import 'package:social_app/features/auth/view/auth_bloc_provider.dart';
import 'package:social_app/features/main_screen/view/main_bloc_provider.dart';
import 'package:social_app/features/auth/view/login_screen/login_screen.dart';
import 'package:social_app/features/auth/view/sign_up_screen/sign_up_screen.dart';
import 'package:social_app/features/auth/view/reset_password_screen/reset_password_screen.dart';
import 'package:social_app/features/auth/view/sign_up_screen/terms_and_conditions_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: GlobalBlocProviderRoute.page,
          children: [
            AutoRoute(page: SplashRoute.page, initial: true),
            AutoRoute(
              page: AuthBlocProviderRoute.page,
              children: [
                AutoRoute(page: LoginRoute.page, initial: true),
                AutoRoute(page: SignUpRoute.page),
                AutoRoute(page: ResetPasswordRoute.page),
                AutoRoute(page: TermsAndConditionsRoute.page),
              ],
            ),
            AutoRoute(
              page: MainScreenBlocProviderRoute.page,
              children: [
                AutoRoute(
                  page: MainRoute.page,
                  initial: true,
                ),
                AutoRoute(page: ChatRoute.page),
              ],
            ),
          ],
        ),
      ];
}
