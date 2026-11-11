import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/auh_model.dart';
import 'auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCubit extends Cubit<LoginState> {
  AuthCubit() : super(LoginInitial());

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();


  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;



  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      emit(LoginFailure('Please enter email and password'));
      return;
    }

    emit(LoginLoading());

    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );



      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emit(LoginFailure('No user found with this email'));
          break;
        case 'wrong-password':
        case 'invalid-credential':
          emit(LoginFailure('Invalid email or password'));
          break;
        case 'invalid-email':
          emit(LoginFailure('Invalid email address'));
          break;
        case 'user-disabled':
          emit(LoginFailure('This account has been disabled'));
          break;
        case 'too-many-requests':
          emit(LoginFailure(
            'Too many attempts. Please try again later',
          ));
          break;
        default:
          emit(LoginFailure(e.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(LoginFailure('Something went wrong'));
    }
  }



  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignUpLoading());

    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty) {
      emit(SignUpFailure('All fields are required'));
      return;
    }

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );



      UserModel userModel = UserModel(
        email: email.trim(),
        name: name.trim(), password: '',
      );
      await store.collection('article').doc(userCredential.user!.uid).set(userModel.toJson());


      emit(SignUpSuccess(userModel));
    } on FirebaseAuthException catch (e) {
      emit(SignUpFailure(e.message ?? 'Registration failed'));
    } catch (e) {
      emit(SignUpFailure('Something went wrong'));
    }
  }



  Future<void> signInWithGoogle() async {
    emit(LoginLoading());

    try {
      debugPrint('GOOGLE LOGIN: started');

      // احذف هذا السطر إذا كنت تهيّئ GoogleSignIn مسبقًا

      debugPrint('GOOGLE LOGIN: initialized');

      final googleUser =
      await GoogleSignIn.instance.authenticate();

      debugPrint('GOOGLE LOGIN: account selected');

      final googleAuth = googleUser.authentication;

      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Google ID token is null');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      await auth.signInWithCredential(credential);

      debugPrint('GOOGLE LOGIN: Firebase success');

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e, st) {
      debugPrint('FIREBASE ERROR: ${e.code} - ${e.message}');
      debugPrintStack(stackTrace: st);
      emit(LoginFailure(e.message ?? e.code));
    } on GoogleSignInException catch (e, st) {
      debugPrint('GOOGLE ERROR: ${e.code} - ${e.description}');
      debugPrintStack(stackTrace: st);
      emit(LoginFailure('Google error: ${e.code}'));
    } catch (e, st) {
      debugPrint('UNKNOWN GOOGLE LOGIN ERROR: $e');
      debugPrintStack(stackTrace: st);
      emit(LoginFailure(e.toString()));
    }
  }

}