import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/domain/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final CollectionReference _userDataCollection =
      FirebaseFirestore.instance.collection('userData');

  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user!;
      var user = MyUser.fromFirebase(firebaseUser);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<MyUser?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential result = await _fAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser = result.user!;
      var user = MyUser.fromFirebase(firebaseUser);
      MyUser myuser = MyUser();

      myuser.email = firebaseUser.email;
      myuser.name = name;
      myuser.id = firebaseUser.uid;

      await _userDataCollection.doc(user.id).set({"data": myuser.toMap()});

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<MyUser?> register(String name, String email, String password) async {
    try{

      final response = await http.post(
        Uri.parse('http://your_django_server/auth/users/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'first_name': name,
        }),
      );

      if (response.statusCode == 201) {
        print('Регистрация успешна');

        MyUser myuser = MyUser();

        myuser.email = email;
        myuser.name = name;
        myuser.id = 'plug';

        return myuser;

      } else {
        print('Ошибка регистрации');

      }

    }catch(e){
      print(e);
      return null;
    }
    return null;

  }






  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<MyUser?> get currentUser {
    return _fAuth
        .authStateChanges()
        .map((User? user) => (user != null && FirebaseAuth.instance.currentUser!.emailVerified) ? MyUser.fromFirebase(user) : null);
  }
}
