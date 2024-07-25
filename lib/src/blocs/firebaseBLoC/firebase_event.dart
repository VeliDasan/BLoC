import 'package:equatable/equatable.dart';

abstract class FirebaseEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUserInfoRequested extends FirebaseEvent {
  final String uid;

  FetchUserInfoRequested({required this.uid});

  @override
  List<Object> get props => [uid];
}
