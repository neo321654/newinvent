import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/domain/user.dart';
import 'invent_end.dart';

class MakeInvent extends StatefulWidget {
  const MakeInvent({Key? key}) : super(key: key);

  @override
  _MakeInventState createState() => _MakeInventState();
}

class _MakeInventState extends State<MakeInvent> {
  MyUser? user;
  int count = 0;
  Map<String, dynamic> listObj = {};
  Map<String, Color?> objList = {};
  List<dynamic> objects = [];

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);
    String time = DateTime.now().year.toString() +
        DateTime.now().month.toString() +
        DateTime.now().day.toString();

    var stream = FirebaseFirestore.instance
        .collection('userData')
        .doc(user!.id)
        .collection('objects')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Инвентаризация',
          style: TextStyle(
            fontSize: 21,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              FirebaseFirestore.instance
                  .collection('userData')
                  .doc(user!.id)
                  .collection('invents')
                  .doc(time)
                  .update({
                'timeEnd':
                    DateFormat.yMd().add_Hm().format(DateTime.now()).toString(),
                'listObj': listObj,
                'objects': objects,
              });

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EndPageInvent(
                        countObj: count,
                        listObj: listObj,
                        time: time,
                        objects: objects,
                      )));
              Fluttertoast.showToast(
                  msg: "Закончена",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
            icon: const Icon(
              Icons.stop_screen_share_outlined,
              color: Colors.white,
            ),
            //label: const SizedBox.shrink(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Что-то пошло не так"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("Идёт загрузка..."),
                );
              }
              count = snapshot.data!.docs.length;

              return Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  // if (stopData) {
                  //   objects.add(data);
                  //   listObj[data['number']] = 0;
                  // }

                  if (objList[data['number']] == null) {
                    objList[data['number']] = Colors.black54;
                    objects.add(data);
                    listObj[data['number']] = 0;
                  }

                  return Card(
                    color: objList[data['number']],
                    child: ListTile(
                      leading: const Icon(
                        Icons.qr_code_outlined,
                        color: Colors.white,
                      ),
                      trailing: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      title: Text(
                        '${data['number']} (${data['object']})',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${data['map']} - ${data['name']} (${data['time']})',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        var result = await BarcodeScanner.scan();

                        if (result.rawContent == data['number']) {
                          TextEditingController countField =
                              TextEditingController();
                          var countObj = 0;

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Введите количество'),
                                content: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: TextField(
                                      controller: countField,
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                          labelText: 'Кол-во', hintText: '10'),
                                    ))
                                  ],
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    child: Text('Ок'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(countField.text.toString());
                                    },
                                  ),
                                ],
                              );
                            },
                          ).then((value) {
                            if (int.parse(value) == int.parse(data['count'])) {
                              setState(() {
                                if (listObj.containsKey(data['number'])) {
                                  listObj.remove(data['number']);
                                }
                                objList[data['number']] = Colors.green;
                              });
                            } else {
                              setState(() {
                                listObj[data['number']] = int.parse(value);
                                objList[data['number']] = Colors.red;
                              });
                              Fluttertoast.showToast(
                                  msg: "Разница на ${int.parse(data['count'] - int.parse(value))} позиции",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          });
                        } else {
                          setState(() {
                            if (!listObj.containsKey(data['number'])) {
                              listObj[data['number']] = 0;
                            }
                            objList[data['number']] = Colors.red;
                          });
                          Fluttertoast.showToast(
                              msg: "Вы отсканировали не тот QR-Code",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
