import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/screens/archive/invent_check.dart';
import '../../domain/user.dart';

class InventListPage extends StatefulWidget {
  const InventListPage({Key? key}) : super(key: key);

  @override
  _InventListStatePage createState() => _InventListStatePage();
}

class _InventListStatePage extends State<InventListPage> {
  MyUser? user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);
    var stream = FirebaseFirestore.instance
        .collection('userData')
        .doc(user!.id)
        .collection('invents')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Архив',
          style: TextStyle(
            fontSize: 21,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
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

              return Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return Card(
                    color: ((data['listObj'].length > 0)
                        ? Colors.red
                        : Colors.green),
                    child: ListTile(
                      leading: const Icon(
                        Icons.inventory,
                        color: Colors.white,
                      ),
                      trailing: const Icon(
                        Icons.turn_right,
                        color: Colors.white,
                      ),
                      title: Text(
                        '${data['timeStart']} - ${data['timeEnd']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${data['names']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        var id = document.id;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => InventCheckPage(
                              id: id,
                                  names: data['names'],
                                  listObj: data['listObj'],
                                  timeEnd: data['timeEnd'],
                                )));
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
