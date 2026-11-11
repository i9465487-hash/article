import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/unilt/valid_input.dart';
import '../../../core/widgit/custommateral.dart';
import '../../../core/widgit/customtextfield.dart';
import '../persentation/cubit/auth_cubit.dart';
import '../persentation/cubit/auth_state.dart';


class Signup extends StatelessWidget {
  Signup({super.key});


  final _formKey =GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController emailSignUp = TextEditingController();
  final TextEditingController passwordSignUp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return
    BlocConsumer<AuthCubit, LoginState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            context.go('/home');
          }

          if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
// Logo / Icon area
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 32),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F6EF7),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4F6EF7).withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      ),

// Title
                      const Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1D2E),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign up to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF8A94A6),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 40),

// Card container
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key:_formKey ,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextField(
                                hintText: "Enter username",
                                show: false,
                                type0: TextInputType.text,
                                obscuretext: false,
                                myController: username,
                                labeltext: 'username',
                                isObscure: false,
                                validator: Validators.validateName,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                hintText: "Enter email",
                                show: false,
                                type0: TextInputType.emailAddress,
                                obscuretext: false,
                                myController: emailSignUp,
                                labeltext: 'Email',
                                isObscure: false,
                                validator: Validators.validateEmail,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                hintText: "Enter password",
                                show: true,
                                type0: TextInputType.text,
                                obscuretext: true,
                                myController: passwordSignUp,
                                labeltext: 'Password',
                                isObscure: true,
                                validator: Validators.validatePassword,
                              ),
                              const SizedBox(height: 28),
                              CustemMateral(
                                chiled: const Text(
                                  'SignUp',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().signUp(
                                      name: username.text,
                                      email: emailSignUp.text,
                                      password: passwordSignUp.text,
                                    );
                                  }

                                },
                              ),



                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

  }

