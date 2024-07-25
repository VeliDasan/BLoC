import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_event.dart';
import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_state.dart';
import 'package:bloc_yapisi/src/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  var collectionKisiler = FirebaseFirestore.instance.collection("Kisiler");

  AuthBloc({required this.authRepository}) : super(UnAuthenticated(error: '')) {
    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signUp(email: event.email, password: event.password);
        emit(SignUpSuccess());
      } catch (e) {
        emit(UnAuthenticated(error: e.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(Loading());
      try {
        bool isAuthenticated = await authRepository.signIn(email: event.email, password: event.password);
        if (isAuthenticated) {
          emit(Authenticated());
        } else {
          emit(UnAuthenticated(error: 'Invalid email or password'));
        }
      } catch (e) {
        emit(UnAuthenticated(error: e.toString()));
      }
    });
  }

}