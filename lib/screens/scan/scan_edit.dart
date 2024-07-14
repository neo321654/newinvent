import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/screens/homePage.dart';

import '../../domain/user.dart';

class ScanEditPage extends StatefulWidget {
  String qrData;
  Map<String, dynamic>? data;

  ScanEditPage({Key? key, required this.qrData, this.data}) : super(key: key);

  @override
  _ScanEditStatePage createState() =>
      _ScanEditStatePage(qrCodeResult: this.qrData, data: this.data);
}

class _ScanEditStatePage extends State<ScanEditPage> {
  MyUser? user;
  String qrCodeResult;
  Map<String, dynamic>? data;

  _ScanEditStatePage({required this.qrCodeResult, this.data});

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Редактирование",
          style: TextStyle(
            fontSize: 21,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Инвентарный номер",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        TextField(
                          enabled: false,
                          controller: TextEditingController(),
                          decoration: InputDecoration(
                            hintText: qrCodeResult,
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const Text(
                          "Дата последнего редактирования",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        TextField(
                          enabled: false,
                          controller: TextEditingController(),
                          decoration: InputDecoration(
                            hintText: data!['time'],
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const Text(
                          "Название объекта",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        TextField(
                          controller: nameObjectField,
                          decoration: InputDecoration(
                            hintText: data!['object'],
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const Text(
                          "Имя редактора",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        TextField(
                          controller: nameAddingField,
                          decoration: InputDecoration(
                            hintText: data!['name'],
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const Text(
                          "Количество",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        TextField(
                          controller: countObjectField,
                          decoration: InputDecoration(
                            hintText: data!['count'],
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const Text(
                          "Местонахождение",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        TextField(
                          controller: mapObjectField,
                          decoration: InputDecoration(
                            hintText: data!['map'],
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  color: Colors.green,
                  padding: const EdgeInsets.all(15.0),
                  child: const Text(
                    "Обновить данные",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () async {
                    String? time = DateFormat.yMd()
                        .add_Hm()
                        .format(DateTime.now())
                        .toString();
                    Map<String, Object?> obj = {'time': time};

                    if (nameObjectField.text.length >= 1) {
                      obj['object'] = nameObjectField.text;
                    }
                    if (nameAddingField.text.length >= 1) {
                      obj['name'] = nameAddingField.text;
                    }
                    if (countObjectField.text.length >= 1) {
                      obj['count'] = countObjectField.text;
                    }
                    if (mapObjectField.text.length >= 1) {
                      obj['status'] = mapObjectField.text;
                    }

                    FirebaseFirestore.instance
                        .collection('userData')
                        .doc(user!.id)
                        .collection('objects')
                        .doc(qrCodeResult)
                        .update(obj)
                        .then((value) => Fluttertoast.showToast(
                            msg: "Данные обновлены",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0))
                        .catchError((error) => Fluttertoast.showToast(
                            msg: "Произошла ошибка",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0));

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final nameObjectField = TextEditingController();
  final nameAddingField = TextEditingController();
  final countObjectField = TextEditingController();
  final mapObjectField = TextEditingController();
}
