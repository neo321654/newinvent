import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/domain/user.dart';

class ScanCheckPage extends StatelessWidget {
  String? qrData;
  MyUser? user;
  Map<String, dynamic>? data;

  ScanCheckPage({this.qrData, this.data});

  Widget _getData(String title, String data, Icon icon) {
    return Column(children: <Widget>[
      Text(
        title,
        style: const TextStyle(
          fontSize: 21,
          fontFamily: 'Oswald',
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 20.0,
      ),
      Container(
        padding: const EdgeInsets.all(10.0),
        color: Color.fromARGB(14, 0, 255, 34),
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 10,
            ),
            Text(
              data,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 20.0,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);
    var stream = FirebaseFirestore.instance
        .collection('userData')
        .doc(user!.id)
        .collection('objects')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Данные объекта"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: Column(
                      children: <Widget>[
                        _getData('Инвентарный номер', data!['number'],
                            Icon(Icons.qr_code)),
                        _getData('Название объекта', data!['object'],
                            const Icon(Icons.table_restaurant)),
                        _getData('Количество', data!['count'],
                            const Icon(Icons.numbers)),
                        _getData('Местонахождение', data!['map'],
                            const Icon(Icons.map)),
                        _getData('Имя последнего редактора данных',
                            data!['name'], Icon(Icons.person)),
                        _getData('Время последнего редактирования',
                            data!['time'], Icon(Icons.timer)),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
