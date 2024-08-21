import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/domain/user.dart';
import 'package:intl/intl.dart';

import 'generate.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({Key? key}) : super(key: key);

  @override
  _GeneratePageState createState() => _GeneratePageState();
}



Future<void> addObject(DocumentReference<Object?> qrcodes, String? inventNum,
    String? nameObj, String? nameAdding, String? countObj, String? mapObj) {
  String? time = DateFormat.yMd().add_Hm().format(DateTime.now()).toString();

  return qrcodes
      .collection('objects')
      .doc(inventNum)
      .set({
        'number': inventNum,
        'object': nameObj,
        'name': nameAdding,
        'count': countObj,
        'map': mapObj,
        'time': time,
      })
      .then((value) => Fluttertoast.showToast(
          msg: "Данные добавлены!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0))
      .catchError((error) {
        print("Failed to add object: $error");
      });
}

class _GeneratePageState extends State<GeneratePage> {
  MyUser? user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);
    DocumentReference qrcodes =
        FirebaseFirestore.instance.collection('userData').doc(user!.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить', style: TextStyle(
          fontSize: 21,
          fontFamily: 'Oswald',
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Введите инвентарный номер",
                  style: TextStyle(fontSize: 18.0),
                ),
                TextField(
                  controller: qrdataFeed,
                  decoration: const InputDecoration(
                    hintText: "M000000145623",
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "Название объекта",
                  style: TextStyle(fontSize: 18.0),
                ),
                TextField(
                  controller: nameObject,
                  decoration: const InputDecoration(
                    hintText: "Компьютерный стол",
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "Количество",
                  style: TextStyle(fontSize: 18.0),
                ),
                TextField(
                  controller: countObjects,
                  decoration: const InputDecoration(
                    hintText: "155",
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "Местонахождение",
                  style: TextStyle(fontSize: 18.0),
                ),
                TextField(
                  controller: mapObject,
                  decoration: const InputDecoration(
                    hintText: "Склад №2",
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "Имя добавляющего",
                  style: TextStyle(fontSize: 18.0),
                ),
                TextField(
                  controller: nameAdding,
                  decoration: const InputDecoration(
                    hintText: "Петров Аркадий",
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                MaterialButton(
                  color: Colors.green,
                  padding: const EdgeInsets.all(15.0),
                  onPressed: () {
                    if (qrdataFeed.text.isEmpty ||
                        nameObject.text.isEmpty ||
                        nameAdding.text.isEmpty ||
                        countObjects.text.isEmpty ||
                        mapObject.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Проверьте введенные данные!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      addObject(qrcodes, qrdataFeed.text, nameObject.text,
                          nameAdding.text, countObjects.text, mapObject.text);
                      Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QrPage(
                          qrData: qrdataFeed.text
                        )));
                    }
                  },
                  child: const Text(
                    "Добавить объект",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final mapObject = TextEditingController();
  final qrdataFeed = TextEditingController();
  final nameObject = TextEditingController();
  final nameAdding = TextEditingController();
  final countObjects = TextEditingController();
}
