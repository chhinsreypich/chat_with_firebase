// ignore_for_file: prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current userr
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  // sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, password) async {
    try {
      // sign user in 
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info if it doesnt already exist
      _firestore.collection('Users').doc(userCredential.user!.uid).set(
        {
          "uid": userCredential.user!.uid,
          "email": email,
        },
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, password) async {
    try {
      // create user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // save user info in a separate doc
      _firestore.collection('Users').doc(userCredential.user!.uid).set(
        {
          "uid": userCredential.user!.uid,
          "email": email,
        },
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign up
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // error
}
