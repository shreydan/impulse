// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulse/core/common/auth_field.dart';
import 'package:impulse/core/constants/constants.dart';
import 'package:impulse/features/home/screen/home_screen.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(dataProvider);
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // textfield 1
            AuthField(
              controller: usernameController,
              hintText: 'Username',
            ),
            const SizedBox(height: 20),
            AuthField(
              controller: passwordController,
              hintText: 'Password',
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () async {
                if (loading) return;

                setState(() {
                  loading = true;
                });
                await prov
                    .auth(
                        username: usernameController.text,
                        password: passwordController.text)
                    .then((value) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ));
                }).catchError((err) {
                  log(err.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid Credentials'),
                    ),
                  );
                });

                setState(() {
                  loading = false;
                });
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(167, 111, 255, 1),
                    borderRadius: BorderRadius.circular(50)),
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
