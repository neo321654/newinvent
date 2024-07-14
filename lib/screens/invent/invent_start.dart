import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/domain/user.dart';
import 'package:untitled3/screens/invent/invent.dart';

class StartPageInvent extends StatefulWidget {
  const StartPageInvent({Key? key}) : super(key: key);

  @override
  _StartPageInventState createState() => _StartPageInventState();
}

class _StartPageInventState extends State<StartPageInvent> {
  MyUser? user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Инвентаризация', style: TextStyle(
          fontSize: 21,
          fontFamily: 'Oswald',
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Кто проводит инвентаризацию?',
                style: TextStyle(fontSize: 18.0),
              ),
              TextField(
                controller: nameAddingField,
                decoration: const InputDecoration(
                  hintText: "Петров Аркадий, Иванов Иван, ...",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.green,
                padding: const EdgeInsets.all(20.0),
                onPressed: () async {
                  if (nameAddingField.text != null) {
                    String docName = DateTime.now().year.toString() + DateTime.now().month.toString() + DateTime.now().day.toString();

                    FirebaseFirestore.instance
                        .collection('userData')
                        .doc(user!.id)
                        .collection('invents')
                        .doc(docName)
                        .set({
                      'names': nameAddingField.text,
                      'timeStart': DateFormat.yMd()
                          .add_Hm()
                          .format(DateTime.now())
                          .toString(),
                      'timeEnd': '',
                      'listObj': [],
                      'objects': []
                    });

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MakeInvent()));
                  } else {
                    Fluttertoast.showToast(
                        msg: "Её должен кто-то проводить....",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 18.0);
                  }
                },
                child: const Text(
                  "Начать",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var nameAddingField = TextEditingController();
}
