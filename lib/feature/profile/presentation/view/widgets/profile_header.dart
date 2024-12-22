import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.userName, required this.userEmail});
  final String userEmail;
  final String userName; // = 'John Doe';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: size.width * 0.10,
            child:  Image.asset(
              'assets/images/profile_image.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10), 
          Text(
            userName,
            style: TextStyle(
             
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
             userEmail,
            style: TextStyle(
              
              fontSize: size.width * 0.035,
            ),
          ),
        ],
     
    );
  }
}
