import 'package:bloc_yapisi/src/pages/list.dart';
import 'package:bloc_yapisi/src/pages/login.dart';
import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_bloc.dart';
import 'package:bloc_yapisi/src/repositories/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_state.dart'; // Ensure this import is present

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => FirebaseBloc(
            FirebaseInitial(), // Use FirebaseInitial as the initial state
            userRepository: UserRepository(),
          ),
        ),
        // Add other providers here if necessary
      ],
      child: MaterialApp(
        title: 'Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Login(),
      ),
    );
  }
}
