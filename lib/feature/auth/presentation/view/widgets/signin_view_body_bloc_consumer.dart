// import 'package:e_commerce/core/utils/common/cusom_progress_hud.dart';
// import 'package:e_commerce/core/utils/constants/colors.dart';
// import 'package:e_commerce/features/auth/presentation/view/signin_view.dart';
// import 'package:e_commerce/features/auth/presentation/view/controller/signin_cubit/sign_in_cubit.dart';
// import 'package:e_commerce/features/auth/presentation/view/widgets/signin_view_body.dart';
// import 'package:e_commerce/features/home/presentation/view/home_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SiginViewBodyBlocConsmer extends StatelessWidget {

//   const SiginViewBodyBlocConsmer({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<SignInCubit, SignInState>(
//       listener: (context, state) {
//         if (state is SignInErrorState) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.errorMessage),
//             ),
//           );
//         }
//         if (state is SignInSuccessState) {

//           Navigator.pushNamed(context,HomeView.routeName);
        
//           ScaffoldMessenger.of(context).showSnackBar(
//          const   SnackBar(
//               backgroundColor: TColors.success,
//               content: Text('تم التسجيل الدخول بنجاح'),
//             ),
//           );
//           // Navigator.pushNamedAndRemoveUntil(
//           //     context, SigninView.routeName, (route) => false);
//         }
//       },
//       builder: (context, state) {
//         return CustomProgressHud( 
//           inLoading: state is SignInloadingState ? true : false,
//          child:  );
//       },
//     );
//   }
// }
