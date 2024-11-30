// import 'package:e_commerce/core/helpers_functions/build_error_method.dart';
// import 'package:e_commerce/core/utils/constants/colors.dart';
// import 'package:e_commerce/features/home/presentation/view/home_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:e_commerce/features/auth/presentation/view/controller/signup_cubit/sign_up_cubit.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'signup_view_body.dart'; // Ensure the correct path is imported

// class SignUpViewBodyBlocConsumer extends StatelessWidget {
//   const SignUpViewBodyBlocConsumer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<SignUpCubit, SignUpState>(
//       listener: (context, state) {
//         if (state is SignUpFailureState) {
//           buildErroMessage(context, state.errorMessage);
//         }
//         if (state is SignUpSuccesState) {
//           Navigator.pushNamed(context, HomeView.routeName);
//           ScaffoldMessenger.of(context).showSnackBar(
//           const  SnackBar(
//               backgroundColor: TColors.success,
//               content: Text('تم التسجيل بنجاح'),
//             ),
//           );
//         }
       
//       },
//       builder: (context, state) {
//         return ModalProgressHUD( 
//           inAsyncCall: state is SignUpLoadingState ? true : false,
//            child:const SignupViewBody()); 
//       },
//     );
//   }


// }