// import 'package:flutter/material.dart';

// class CustomPageRoute extends PageRouteBuilder {
//   final Widget child;

//   CustomPageRoute({required this.child})
//       : super(
//           transitionDuration: const Duration(milliseconds: 500),
//           pageBuilder: (context, animation, secondaryAnimation) => child,
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             const begin = Offset(1.0, 0.0);
//             const end = Offset.zero;
//             const curve = Curves.easeInOutCubic;

//             var tween = Tween(begin: begin, end: end).chain(
//               CurveTween(curve: curve),
//             );

//             var offsetAnimation = animation.drive(tween);

//             var fadeAnimation = Tween<double>(
//               begin: 0.0,
//               end: 1.0,
//             ).animate(
//               CurvedAnimation(
//                 parent: animation,
//                 curve: curve,
//               ),
//             );

//             return SlideTransition(
//               position: offsetAnimation,
//               child: FadeTransition(
//                 opacity: fadeAnimation,
//                 child: child,
//               ),
//             );
//           },
//         );
// }
