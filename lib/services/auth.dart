import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled3/domain/user.dart';

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

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<MyUser?> get currentUser {
    return _fAuth
        .authStateChanges()
        .map((User? user) => (user != null && FirebaseAuth.instance.currentUser!.emailVerified) ? MyUser.fromFirebase(user) : null);
  }
}
