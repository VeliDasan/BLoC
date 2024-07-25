import 'package:bloc_yapisi/src/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_event.dart';
import 'firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  final UserRepository userRepository;

  FirebaseBloc(super.initialState, {required this.userRepository}) {
    on<FetchUserInfoRequested>((event, emit) async {
      try {
        DocumentSnapshot userInfo = await userRepository.getUserInfo(event.uid);
        emit(UserInfoLoaded(userInfo: userInfo));
      } catch (e) {
        emit(FirebaseError(error: e.toString()));
      }
    });
  }
}
