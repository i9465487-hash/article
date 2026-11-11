

import 'package:artical/featheres/artical/scereen/article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../scereen/login.dart';
import '../../scereen/signup.dart';
import '../cubit/auth_cubit.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => AuthCubit(),
          child: Login(),
        );
      },
    ),


    GoRoute(
      path: '/signup',
      builder: (context, state) => BlocProvider(
        create: (_) => AuthCubit(),
        child: Signup(),
      ),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => ArticlesPage(),
    ),
  ],
);