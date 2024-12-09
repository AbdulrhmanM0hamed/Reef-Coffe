// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:hyper_market/feature/auth/domain/entities/user_entity.dart';
// import 'package:hyper_market/feature/auth/domain/repositories/auth_repository.dart';

// part 'auth_state.dart';

// class AuthentcationCubit extends Cubit<AuthentcationState> {
//   final AuthRepository authRepository;

//   AuthentcationCubit({required this.authRepository}) : super(AuthInitialState());

//   Future<void> signInWithEmail(String email, String password) async {
//     emit(AuthLoadingState());

//     final result =
//         await authRepository.signInWithEmail(email: email, password: password);

//     result.fold(
//       (failure) => emit(AuthErrorState(failure.message)),
//       (user) => emit(AuthSignedInState(user)),
//     );
//   }

//   Future<void> signUpWithEmail(
//       String email, String password, String name) async {
//     emit(AuthLoadingState());

//     final result = await authRepository.signUpWithEmail(
//         email: email, password: password, name: name);

//     result.fold(
//       (failure) => emit(AuthErrorState(failure.message)),
//       (user) => emit(AuthSignedInState(user)),
//     );
//   }

//   Future<void> signOut() async {
//     emit(AuthLoadingState());

//     final result = await authRepository.signOut();

//     result.fold(
//       (failure) => emit(AuthErrorState(failure.message)),
//       (_) => emit(AuthSignedOutState()),
//     );
//   }

//   Future<void> getCurrentUser() async {
//     emit(AuthLoadingState());

//     final result = await authRepository.getCurrentUser();

//     result.fold(
//       (failure) => emit(AuthErrorState(failure.message)),
//       (user) {
//         if (user != null) {
//           emit(AuthSignedInState(user));
//         } else {
//           emit(AuthSignedOutState());
//         }
//       },
//     );
//   }

//   Future<void> resetPassword(String email) async {
//     emit(AuthLoadingState());

//     final result = await authRepository.resetPassword(email);

//     result.fold(
//       (failure) => emit(AuthErrorState(failure.message)),
//       (_) => emit(AuthSignedOutState()),
//     );
//   }

//   Future<void> signInWithGoogle() async {
//     emit(AuthLoadingState());

//     final result = await authRepository.signInWithGoogle();

//     result.fold(
//       (failure) => emit(AuthErrorState(failure.message)),
//       (user) => emit(AuthSignedInState(user)),
//     );
//   }

//   Future<void> signInWithFacebook() async {
//     emit(AuthLoadingState());

//     final result = await authRepository.signInWithFacebook();

//     result.fold(
//       (failure) => emit(AuthErrorState(failure.message)),
//       (user) => emit(AuthSignedInState(user)),
//     );
//   }
// }
