import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/login/login_cubit.dart';
import '../repositories/authentication/authentication_repository.dart';

///
class LogInScreen extends StatelessWidget {
  ///
  const LogInScreen({Key key}) : super(key: key);

  ///
  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const LogInScreen());

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: BlocProvider(
            create: (context) => LogInCubit(
                authenticationRepository: AuthenticationRepository()),
            child: Align(
              alignment: const Alignment(0, -1 / 3),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Image.asset(
                      'assets/givenow-logo.png',
                      height: 150,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  _GoogleLogInButton()
                ],
              ),
            ),
          ),
        ),
      );
}

class _GoogleLogInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ElevatedButton(
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
      onPressed: () => context.read<LogInCubit>().logIn(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/google_logo.png',
              height: 40,
              width: 50,
            ),
            const SizedBox(width: 4),
            const Text(
              'Log in with Google',
              style: TextStyle(fontSize: 26, color: Colors.black),
            )
          ],
        ),
      ));
}
