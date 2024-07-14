import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:untitled3/domain/user.dart';
import 'package:untitled3/screens/invent/invent_end.dart';
import '../homePage.dart';

class InventCheckPage extends StatelessWidget {
  Map<String, dynamic> listObj;
  String? timeEnd;
  String? names;
  String? id;
  MyUser? user;

  InventCheckPage({this.id, required this.listObj, this.timeEnd, this.names});

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Результат',
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
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Инвентаризация пройдена: $timeEnd',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              ((listObj.length > 0)
                  ? Text(
                      'Участие в инвентаризации принимали: $names.\nК сожалению, по завершению работы была выявлена недосдача. Не были обнаружены следующие объекты: ${listObj.keys.join(', ')}.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      'Участие в инвентаризации принимали: $names.\nРезультат получился успешный.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center)),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.green,
                padding: EdgeInsets.all(20.0),
                onPressed: () async {
                  Fluttertoast.showToast(
                              msg: "Пожалуйста, подождите несколько секунд",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                              fontSize: 16.0);

                  final xls.Workbook workbook = xls.Workbook();

                  Excel.createExcel(user!, workbook, id!);
                },
                child: const Text(
                  'Открыть таблицу',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45.0)),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.black54,
                padding: EdgeInsets.all(20.0),
                onPressed: () async {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
                child: const Text(
                  'Вернуться на главную',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45.0)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
