import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../locales/strings.dart';
import '../../../navigation/app_router.dart';
import 'bloc/main_screen_bloc.dart';
import 'bloc/main_screen_event.dart';
import 'bloc/main_screen_state.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.appName,
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<MainScreenBloc, MainScreenState>(
          bloc: bloc,
          listener: (context, state) {
            if (state.haveError) {
              showDialog(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 400.0,
                    width: 400.0,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(state.error!.name),
                          Text(state.error!.description),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            if(state.connected){
              context.pushRoute(const ChatRoute());
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 24.0,
                  ),
                  child: TextField(
                    onChanged: (text) {
                      bloc.add(
                          MainScreenEvent.addressChanged(newAddress: text));
                    },
                    onSubmitted: (text) {
                      bloc.add(const MainScreenEvent.connectionAttempt());
                    },
                    decoration: InputDecoration(
                      hintText: Strings.addressHint,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            45.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade200),
                  onPressed: () {
                    bloc.add(const MainScreenEvent.connectionAttempt());
                  },
                  child: Text(
                    Strings.connect,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
