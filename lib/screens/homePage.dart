import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/main.dart';
import 'package:untitled3/screens/about_app.dart';
import 'package:untitled3/screens/gener/add_obj.dart';
import 'package:untitled3/screens/gener/gener_objects.dart';
import 'package:untitled3/screens/scan/scan_choice.dart';
import 'package:file_picker/file_picker.dart';
import 'package:untitled3/services/auth.dart';
import '../domain/user.dart';
import 'archive/invent_list.dart';
import 'invent/invent_start.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyStateHomePage();
}

class _MyStateHomePage extends State<MyHomePage> {
  MyUser? user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Invent',
            style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AboutPage()));
              },
              icon: const Icon(
                Icons.contact_support,
                color: Colors.white,
              ),
              //label: SizedBox.shrink(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _MaterialButton("Начать инвентаризацию", const StartPageInvent()),
                const SizedBox(
                  height: 20.0,
                ),
                MaterialButton(
                  color: Colors.green,
                  padding: const EdgeInsets.all(20.0),
                  onPressed: () async {
                    var result = await BarcodeScanner.scan();

                    if (result.rawContent.isNotEmpty) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ScanChoicePage(
                                qrData: result.rawContent,
                              )));
                    } else {
                      Fluttertoast.showToast(
                          msg: "Попробуйте ещё-раз",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.yellow,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: const Text(
                    "Сканируйте QR-CODE",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0)),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                _MaterialButton("Добавить объект", const GeneratePage()),
                const SizedBox(
                  height: 20.0,
                ),
                MaterialButton(
                  color: Colors.green,
                  padding: const EdgeInsets.all(20.0),
                  onPressed: () async {
                    String? names;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Кто добавляет?'),
                          content: Row(
                            children: <Widget>[
                              Expanded(
                                  child: TextField(
                                controller: namesField,
                                autofocus: true,
                                decoration: const InputDecoration(
                                    labelText: 'Вставьте имя',
                                    hintText: 'Петров Аркадий'),
                              ))
                            ],
                          ),
                          actions: <Widget>[
                            MaterialButton(
                              child: Text('Далее'),
                              onPressed: () {
                                Navigator.of(context).pop(namesField.text);
                              },
                            ),
                          ],
                        );
                      },
                    ).then((value) async {
                      String? time = DateFormat.yMd()
                          .add_Hm()
                          .format(DateTime.now())
                          .toString();
                      names = value.toString();
                      namesField.clear();

                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        PlatformFile file = result.files.first;

                        var fileName = file.path!;
                        var bytes = File(fileName).readAsBytesSync();
                        var excel = Excel.decodeBytes(bytes);
                        var objects = [];

                        for (var table in excel.tables.keys) {
                          for (var row in excel.tables[table]!.rows) {
                            var data = [];
                            for (int i = 0; i < 4; i++) {
                              data.add(row[i]!.value);
                            }
                            objects.add([data[0], data[3]]);
                            FirebaseFirestore.instance
                                .collection('userData')
                                .doc(user!.id)
                                .collection('objects')
                                .doc(data[0])
                                .set({
                              'number': data[0],
                              'object': data[1],
                              'name': names,
                              'count': data[3],
                              'map': data[2],
                              'time': time,
                            });
                          }
                        }

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => QrMorePage(qrData: objects)));
                      } else {
                        // User canceled the picker
                      }
                    });
                  },
                  child: const Text(
                    "Загрузка данных",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0)),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                _MaterialButton("Архив", InventListPage()),
                const SizedBox(
                  height: 20.0,
                ),
                MaterialButton(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(20.0),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => MyApp()));
                    AuthService().logOut();
                  },
                  child: const Text(
                    "Выйти из аккаунта",
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
        ));
  }

  Widget _MaterialButton(String text, Widget widget) {
    return MaterialButton(
      color: Colors.green,
      padding: const EdgeInsets.all(20.0),
      onPressed: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget));
      },
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
    );
  }

  TextEditingController namesField = TextEditingController();
}
