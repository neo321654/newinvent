import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/domain/user.dart';
import 'package:untitled3/screens/homePage.dart';
import 'package:untitled3/screens/scan/scan_check.dart';
import 'package:untitled3/screens/scan/scan_edit.dart';

class ScanChoicePage extends StatelessWidget {
  String? qrData;
  MyUser? user;
  Map<String, dynamic>? data;

  ScanChoicePage({this.qrData});

  Future<Map<String, dynamic>?> _getData(
      MyUser user, String qrCodeResult) async {
    var getData = await FirebaseFirestore.instance
        .collection('userData')
        .doc(user.id)
        .collection('objects')
        .doc(qrCodeResult)
        .get();

    var list = getData.data();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);

    _getData(user!, qrData!).then((value) => data = value);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Меню", style: TextStyle(
          fontSize: 21,
          fontFamily: 'Oswald',
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Выберите действие над объектом',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 40,
            ),
            MaterialButton(
              color: Colors.green,
              padding: EdgeInsets.all(15.0),
              child: const Text(
                "Посмотреть данные",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScanCheckPage(qrData: qrData, data: data,)));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              color: Colors.green,
              padding: EdgeInsets.all(15.0),
              child: const Text(
                "Отредактировать данные",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScanEditPage(qrData: qrData!, data: data,)));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
                color: Colors.green,
                padding: EdgeInsets.all(15.0),
                child: const Text(
                  "Удалить объект",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('userData')
                      .doc(user!.id)
                      .collection('objects')
                      .doc(qrData)
                      .delete()
                      .then((value) => Fluttertoast.showToast(
                          msg: "Данные удалены",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                          fontSize: 16.0))
                      .catchError((error) {
                    print(error);
                    Fluttertoast.showToast(
                        msg: "Возникла ошибка",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MyHomePage()));
                }),
          ],
        ),
      )),
    );
  }
}
