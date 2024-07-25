import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_bloc.dart';
import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_event.dart';
import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<FirebaseBloc>().add(FetchUserInfoRequested(uid: user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
      ),
      body: BlocBuilder<FirebaseBloc, FirebaseState>(
        builder: (context, state) {
          if (state is FirebaseLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserInfoLoaded) {
            print('UserInfoLoaded state received');
            final userInfo = state.userInfo.data() as Map<String, dynamic>?;

            if (userInfo != null) {
              print('User info: $userInfo');
              return Card(
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${userInfo['email'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18.0)),
                      Text('Created At: ${userInfo['createdAt']?.toDate() ??
                          'N/A'}', style: TextStyle(fontSize: 18.0)),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('No user information available'));
            }
          } else if (state is FirebaseError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Center(child: Text('No user information available'));
          }
        },
      ),
    );
  }
}