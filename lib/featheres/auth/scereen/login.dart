import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/unilt/valid_input.dart';
import '../../../core/widgit/custommateral.dart';
import '../../../core/widgit/customtextfield.dart';
import '../persentation/cubit/auth_cubit.dart';
import '../persentation/cubit/auth_state.dart';


class Login extends StatelessWidget {
  Login({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, LoginState>(

      listener: (context, state) {
        if (state is LoginSuccess) {

          context.go('/home');
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('error')),
          );
        }
      },

      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: "Enter email",
                        show: false,
                        type0: TextInputType.emailAddress,
                        obscuretext: false,
                        myController: email,
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
                        myController: password,
                        labeltext: 'Password',
                        isObscure: true,
                        validator: Validators.validatePassword,

                      ),
                      TextButton(onPressed: (){
                        context.go("/forgot");
                      }, child: Text('forgot password ?')),

                      const SizedBox(height: 20),

                      CustemMateral(
                        chiled: state is LoginLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Login'),

                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                              email: email.text,
                              password: password.text,
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 28),
                      ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                          debugPrint('GOOGLE BUTTON PRESSED');
                          context.read<AuthCubit>().signInWithGoogle();
                        },
                        icon: const Icon(Icons.g_mobiledata, size: 30),
                        label: Text(
                          isLoading ? 'Please wait...' : 'Sign in with Google',
                        ),
                      ),

                      SizedBox(height: 28,),

                      TextButton(onPressed: (){
                        context.go('/signup');
                      }, child: Text('Create Account')),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}