import 'package:chatapp/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
  ) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        //log in
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email.toString(), password: password);
      } else {
        //sign up
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final _firestoreInstance = FirebaseFirestore.instance;
        await _firestoreInstance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
      setState(() {
        _isLoading = false;
      });
    } on FirebaseException catch (err) {
      var message = "An error occured, please check your credentials";

      if (err.message != null) {
        message = err.message!;
      }
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('An Error occurred'),
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
