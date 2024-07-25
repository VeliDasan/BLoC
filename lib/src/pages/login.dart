import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_bloc.dart';
import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_event.dart';
import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_state.dart';
import 'package:bloc_yapisi/src/elements/pageLoading.dart';
import 'package:bloc_yapisi/src/pages/list.dart';
import 'package:bloc_yapisi/src/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Login'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Login'),
                  Tab(text: 'Sign Up'),
                ],
              ),
            ),
            body: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListScreen(),
                    ),
                  );
                }
                if (state is UnAuthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.error}')),
                  );
                }
                if (state is SignUpSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sign Up Successful')),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TabBarView(
                  children: [
                    _buildLoginTab(context),
                    _buildSignUpTab(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTab(BuildContext context) {
    final TextEditingController _loginEmailController =
    TextEditingController();
    final TextEditingController _loginPasswordController =
    TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _loginEmailController,
          decoration: const InputDecoration(labelText: 'Login Email'),
        ),
        TextField(
          controller: _loginPasswordController,
          decoration: const InputDecoration(labelText: 'Login Password'),
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
                final email = _loginEmailController.text;
                final password = _loginPasswordController.text;
                context
                    .read<AuthBloc>()
                    .add(LoginRequested(email: email, password: password));
              },
              child: const Text('Login'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSignUpTab(BuildContext context) {
    final TextEditingController _signUpEmailController =
    TextEditingController();
    final TextEditingController _signUpPasswordController =
    TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _signUpEmailController,
          decoration: const InputDecoration(labelText: 'Sign Up Email'),
        ),
        TextField(
          controller: _signUpPasswordController,
          decoration: const InputDecoration(labelText: 'Sign Up Password'),
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
                final email = _signUpEmailController.text;
                final password = _signUpPasswordController.text;
                context
                    .read<AuthBloc>()
                    .add(SignUpRequested(email: email, password: password));
              },
              child: const Text('Sign Up'),
            );
          },
        ),
      ],
    );
  }
}
