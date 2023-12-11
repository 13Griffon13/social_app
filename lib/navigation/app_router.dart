import 'package:auto_route/auto_route.dart';
import 'package:social_app/features/main_screen/view/main_screen.dart';
import 'package:social_app/features/chat_screen/view/chat_screen.dart';


part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: MainRoute.page,
          initial: true,
        ),
        AutoRoute(page: ChatRoute.page),
      ];
}
