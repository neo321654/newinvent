import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled3/domain/user.dart';
import 'package:untitled3/main.dart';
import 'package:untitled3/screens/fogot_pass.dart';
import 'package:untitled3/screens/homePage.dart';
import 'package:untitled3/services/auth.dart';
import 'package:untitled3/services/landing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key? key}) : super(key: key);

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<AuthorizationPage> {
  final _emailController = TextEditingController(text:"testuser@example.com");
  final _passwordController = TextEditingController(text:"yourpassword");
  final _nameController = TextEditingController();

  bool showLogin = true;

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Widget _logo() {
      return Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 20),
          child: Container(
            child: const Align(
                child: Text(
              'INVENT',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald',
              ),
            )),
          ));
    }

    Widget _input(Icon icon, String hint, TextEditingController controller,
        bool obscure) {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            hintStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black26),
            hintText: hint,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 3),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45, width: 1),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data: const IconThemeData(color: Colors.black),
                child: icon,
              ),
            ),
          ),
        ),
      );
    }

    Widget _button(String text, void func()) {
      return MaterialButton(
        splashColor: Color.fromARGB(255, 59, 59, 59),
        highlightColor: Colors.green,
        color: Colors.black,
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        onPressed: () {
          func();
        },
      );
    }

    Widget _form(String label, void func()) {
      return Container(
          child: Center(
        child: Column(
          children: <Widget>[
            (!showLogin
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _input(const Icon(Icons.person), "Организация",
                        _nameController, false),
                  )
                : const SizedBox(
                    height: 0,
                  )),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _input(const Icon(Icons.email), "Электронная почта",
                  _emailController, false),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _input(const Icon(Icons.lock), "Пароль",
                    _passwordController, true)),
            (showLogin ?
            (Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: GestureDetector(
                child: const Text(
                  "Забыл пароль?",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FogotPassPage()));
                },
              ),
            )) : Text('')),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: _button(label, func),
              ),
            )
          ],
        ),
      ));
    }

    Future<void> _loginButtonAction() async {
      String? _email = _emailController.text;
      String? _password = _passwordController.text;

      if (_email.isEmpty || _password.isEmpty) return;

      MyUser? user = await _authService.signInWithEmailAndPassword(
          _email.trim(), _password.trim());

      if (user != null) {
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          print(FirebaseAuth.instance.currentUser!.emailVerified);

          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MyApp()));
          _emailController.clear();
          _passwordController.clear();
        } else {
          Fluttertoast.showToast(
            msg: "Вы ещё не активировали аккаунт",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Неправильно ввели почту или пароль",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    Future<void> _loginButtonActionMy() async {

      String? _email = _emailController.text;
      String? _password = _passwordController.text;

      if (_email.isEmpty || _password.isEmpty) return;

      MyUser? user = await _authService.signInWithEmailAndPasswordMy(
          _email.trim(), _password.trim());


    }

    Future<void> _registerButtonAction() async {
      String? _name = _nameController.text;
      String? _email = _emailController.text;
      String? _password = _passwordController.text;
      RegExp regExpMail = RegExp(
          "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+");
      RegExp regExpPass = RegExp(r'^.{6,}$');

      if (_email.isEmpty || _password.isEmpty || _name.isEmpty) return;

      if (!regExpMail.hasMatch(_email)) {
        Fluttertoast.showToast(
            msg: "Неверная почта",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      if (!regExpPass.hasMatch(_password)) {
        Fluttertoast.showToast(
            msg: "Слишком короткий пароль",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      // MyUser? user = await _authService.registerWithEmailAndPassword(
      //     _name.trim(), _email.trim(), _password.trim());

      MyUser? user = await _authService.register(
          _name.trim(), _email.trim(), _password.trim());
      if (user == null) {
        Fluttertoast.showToast(
            msg: "Неправильно ввели почту или пароль",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        FirebaseAuth.instance.currentUser!.sendEmailVerification();

        setState(() {
          showLogin = true;
        });

        Fluttertoast.showToast(
            msg: "Подтвердите почту",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 60,
                ),
                Image.asset(
                  'assets/images/icona.png',
                  scale: 2,
                ),
                _logo(),
                (showLogin
                    ? Column(
                        children: <Widget>[
                          // _form('Войти', _loginButtonAction),
                          _form('Войти', _loginButtonActionMy),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                              child: const Text(
                                "Ещё не зарегистрированы?\nПройдите регистрацию!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  showLogin = false;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          _form('Регистрация', _registerButtonAction),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                              child: const Text(
                                "Уже зарегистрированны?\nВойдите",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  showLogin = true;
                                });
                              },
                            ),
                          ),
                        ],
                      )),
              ],
            ),
          ),
        ));
  }
}
