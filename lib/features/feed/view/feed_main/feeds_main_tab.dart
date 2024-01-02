import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'FeedMainRoute')
class FeedsMainTab extends StatelessWidget {
  const FeedsMainTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Feeds will be here'),
    );
  }
}
