import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_bloc.dart';
import 'package:bloc_yapisi/src//blocs/loginBLoC/auth_event.dart';
import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_state.dart';
import '../elements/pageLoading.dart';

Widget buildSignUpTab(BuildContext context) {
  final TextEditingController _signUpNameController =
  TextEditingController();
  final TextEditingController _signUpSurnameController =
  TextEditingController();
  final TextEditingController _signUpEmailController =
  TextEditingController();
  final TextEditingController _signUpPasswordController =
  TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _signUpNameController,
          decoration: InputDecoration(
            labelText: 'Ad',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _signUpSurnameController,
          decoration: InputDecoration(
            labelText: 'Soyad',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _signUpEmailController,
          decoration: InputDecoration(
            labelText: 'E-posta',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _signUpPasswordController,
          decoration: InputDecoration(
            labelText: 'Şifre',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading) {
              return pageLoading();
            }
            return ElevatedButton(
              onPressed: () {
                try {
                  FocusManager.instance.primaryFocus?.unfocus();
                } catch (e) {}

                final email = _signUpEmailController.text;
                final password = _signUpPasswordController.text;
                final name = _signUpNameController.text;
                final surname = _signUpSurnameController.text;
                context.read<AuthBloc>().add(SignUpRequested(email: email, password: password, name: name, surname: surname,));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4a4b65)
              ),
              child: const Text('Kayıt Ol',style: TextStyle(color: Colors.white)),

            );
          },
        ),
      ],
    ),
  );
}