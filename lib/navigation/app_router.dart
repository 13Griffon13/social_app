import 'package:auto_route/auto_route.dart';
import 'package:social_app/features/main_screen/view/main_screen/main_screen.dart';
import 'package:social_app/core/view/global_bloc_provider.dart';
import 'package:social_app/features/auth/view/splash_screen/splash_screen.dart';
import 'package:social_app/features/auth/view/auth_bloc_provider.dart';
import 'package:social_app/features/main_screen/view/main_bloc_provider.dart';
import 'package:social_app/features/auth/view/login_screen/login_screen.dart';
import 'package:social_app/features/auth/view/sign_up_screen/sign_up_screen.dart';
import 'package:social_app/features/auth/view/reset_password_screen/reset_password_screen.dart';
import 'package:social_app/features/auth/view/sign_up_screen/terms_and_conditions_screen.dart';
import 'package:social_app/features/user_profile/view/nickname_screen/nickname_screen.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/profile_setup_screen.dart';
import 'package:social_app/features/user_profile/view/profile_screen/profile_screen.dart';
import 'package:social_app/features/feed/view/feed_main/feeds_main_tab.dart';

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
                  children: [
                    AutoRoute(page: ProfileRoute.page, initial: true),
                    AutoRoute(page: FeedMainRoute.page),
                  ],
                ),
                AutoRoute(page: ProfileSetupRoute.page),
              ],
            ),
          ],
        ),
      ];
}
