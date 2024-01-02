import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:social_app/features/main_screen/view/main_screen/right_drawer.dart';
import 'package:social_app/navigation/app_router.dart';


@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final bloc = context.read<MainScreenBloc>();
    return AutoTabsRouter(
      routes: [
        FeedMainRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          appBar: AppBar(
          ),
          drawer: RightDrawer(),
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) {
              tabsRouter.setActiveIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.feed),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              ),
            ],
          ),
        );
      },
    );
  }
}
