import 'package:bloc_yapisi/src/elements/pageLoading.dart';
import 'package:bloc_yapisi/src/pages/login.dart';
import 'package:bloc_yapisi/src/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_bloc.dart';
import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_event.dart';
import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_state.dart';
import 'package:bloc_yapisi/src/elements/locationButton.dart';
import 'package:bloc_yapisi/src/utils/global.dart';

import '../widgets/build_text.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _emailController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return BlocProvider(
      create: (context) => FirebaseBloc(
        FirebaseInitial(),
        userRepository: UserRepository(),
      )..add(FetchUserInfoRequested(uid: user!.uid)),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              "Kullanıcı Bilgileri",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: appBarBackgroundColor,
          ),
          body: BlocListener<FirebaseBloc, FirebaseState>(
            listener: (context, state) {
              if (state is UserDeleted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false,
                );
              } else if (state is UserInfoUpdated) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Güncelleme Durumu'),
                      content: const Text(
                          'Bilgileriniz güncellenmiştir, giriş ekranına yönlendiriliyorsunuz...'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                                  (route) => false,
                            );
                          },
                          child: const Text('Tamam'),
                        ),
                      ],
                    );
                  },
                );
              } else if (state is UserPasswordUpdated) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Güncelleme Durumu'),
                      content: const Text(
                          'Şifreniz güncellenmiştir, giriş ekranına yönlendiriliyorsunuz...'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                                  (route) => false,
                            );
                          },
                          child: const Text('Tamam'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: BlocBuilder<FirebaseBloc, FirebaseState>(
              builder: (context, state) {
                if (state is FirebaseLoading) {
                  return Center(child: pageLoading());
                } else if (state is UserInfoLoaded) {
                  final userInfo =
                  state.userInfo.data() as Map<String, dynamic>?;

                  if (userInfo != null) {
                    _emailController.text = userInfo['email'] ?? 'N/A';
                    _nameController.text = userInfo['name'] ?? 'N/A';
                    _surnameController.text = userInfo['surname'] ?? 'N/A';

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          buildTextFormField(
                            controller: _emailController,
                            labelText: "Yeni Email Adresinizi Giriniz",
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email boş olamaz';
                              }
                              return null;
                            },
                            icon: Icons.email,
                            iconColor: Colors.blue,
                          ),
                          buildTextFormField(
                            controller: _nameController,
                            labelText: "Ad",
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ad boş olamaz';
                              }
                              return null;
                            },
                            icon: Icons.person,
                            iconColor: Colors.green,
                          ),
                          buildTextFormField(
                            controller: _surnameController,
                            labelText: "Soyad",
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Soyad boş olamaz';
                              }
                              return null;
                            },
                            icon: Icons.person,
                            iconColor: Colors.green,
                          ),
                          buildTextFormField(
                            controller: _oldPasswordController,
                            obscureText: true,
                            labelText: "Eski Şifrenizi Giriniz",
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Eski şifre boş olamaz';
                              }
                              return null;
                            },
                            icon: Icons.lock,
                            iconColor: Colors.red,
                          ),
                          buildTextFormField(
                            controller: _newPasswordController,
                            labelText: "Yeni Şifrenizi Giriniz",
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Yeni şifre boş olamaz';
                              }
                              return null;
                            },
                            icon: Icons.lock,
                            iconColor: Colors.red,
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              locationButton(
                                onPressed: () {
                                  final newEmail = _emailController.text;
                                  final newName = _nameController.text;
                                  final newSurname = _surnameController.text;
                                  if (newEmail.isNotEmpty) {
                                    final updatedData = {
                                      'email': newEmail,
                                      'name': newName,
                                      'surname': newSurname
                                    };
                                    context.read<FirebaseBloc>().add(
                                      UpdateUserInfoRequested(
                                        uid: user!.uid,
                                        data: updatedData,
                                      ),
                                    );
                                  }
                                },
                                title: 'Güncelle',
                              ),
                              locationButton(
                                onPressed: () {
                                  context.read<FirebaseBloc>().add(
                                    DeleteUserRequested(uid: user!.uid),
                                  );
                                },
                                title: 'Hesabı Sil',
                              ),
                              locationButton(
                                onPressed: () {
                                  final oldPassword =
                                      _oldPasswordController.text;
                                  final newPassword =
                                      _newPasswordController.text;
                                  if (oldPassword.isNotEmpty &&
                                      newPassword.isNotEmpty) {
                                    context.read<FirebaseBloc>().add(
                                      UpdatePasswordRequested(
                                        oldPassword: oldPassword,
                                        newPassword: newPassword,
                                      ),
                                    );
                                  }
                                },
                                title: 'Şifreyi Güncelle',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                        child: Text('No user information available'));
                  }
                } else if (state is FirebaseError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return const Center(
                      child: Text('No user information available'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}