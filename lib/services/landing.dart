import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/domain/user.dart';
import 'package:untitled3/screens/auth.dart';
import 'package:untitled3/screens/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final MyUser? user = Provider.of<MyUser?>(context);

    return (user != null)
        ? MyHomePage()
        : AuthorizationPage();
  }
}
