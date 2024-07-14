import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/domain/user.dart';
import 'package:untitled3/screens/auth.dart';

class FogotPassPage extends StatefulWidget {
  const FogotPassPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FogotPassPageState();
}

class _FogotPassPageState extends State<FogotPassPage> {
  MyUser? user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
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
              Padding(
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
                  )),
              Text(
                'Введите свою электронную почту для сброса пароля',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _emailController,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black26),
                  hintText: 'Электронная почта',
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
                      child: Icon(Icons.email),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    splashColor: Color.fromARGB(255, 59, 59, 59),
                    highlightColor: Colors.green,
                    color: Colors.black,
                    child: Text(
                      'Отправить',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white),
                    ),
                    onPressed: () async {
                      try {
                        FirebaseAuth.instance.sendPasswordResetEmail(
                            email: _emailController.text.trim());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AuthorizationPage()));
                        Fluttertoast.showToast(
                            msg: "Собщение отправлено!!!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } on FirebaseAuthException catch (e) {
                        print(e);
                        Fluttertoast.showToast(
                            msg: "Попробуйте ввести почту ещё раз",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final _emailController = TextEditingController();
}
