import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String userNickname;
  final double radius;

  const UserAvatar({
    super.key,
    required this.userNickname,
    this.avatarUrl,
    this.radius = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    if(avatarUrl == null || avatarUrl!.isEmpty){
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.deepPurple.shade300,
        child: Text(
          userNickname[0],
          style: TextStyle(
            fontSize: radius,
          ),
        ),
      );
    }else{
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(avatarUrl!),
      );
    }
  }
}
