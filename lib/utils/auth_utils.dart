import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:local_auth/local_auth.dart';



class AuthUtils {
  static final AuthUtils instance = AuthUtils._getInstance();

  AuthUtils._getInstance();

  Future<UserCredential> loginGoogle() async {
    Completer<UserCredential> completer = Completer();
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;
      if (googleAuth != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Once signed in, return the UserCredential
        var userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        completer.complete(userCredential);
      }
    } on Exception catch (e) {
      completer.completeError(e);
      print("error$e");
    }
    return completer.future;
  }

  Future<UserCredential?> loginFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if(result.status == LoginStatus.success){
      // Create a credential from the access token
      final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    return null;
  }

  Future<UserCredential> loginApple() async {
    List<Scope> scopes = [];
    Completer<UserCredential> completer = Completer();
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        completer.complete(userCredential);
        break;
      // final firebaseUser = userCredential.user!;
      // if (scopes.contains(Scope.fullName)) {
      //   final fullName = appleIdCredential.fullName;
      //   if (fullName != null &&
      //       fullName.givenName != null &&
      //       fullName.familyName != null) {
      //     final displayName = '${fullName.givenName} ${fullName.familyName}';
      //     await firebaseUser.updateDisplayName(displayName);
      //   }
      // }
      // return firebaseUser;
      case AuthorizationStatus.error:
        completer.completeError(result.error!);
        break;
      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
    return completer.future;
  }


  //FirebaseAuth
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future loginFirebase(String email, String password)async {
    Completer completer = Completer();
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
      completer.complete(credential);
    } catch(e) {
      completer.completeError(e);
    }

    return completer.future;


  }


  //Biometric

  
  
}
