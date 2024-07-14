import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/domain/user.dart';
import 'package:untitled3/screens/homePage.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:open_file/open_file.dart';

class EndPageInvent extends StatefulWidget {
  int? countObj;
  Map<String, dynamic> listObj;
  String? time;
  List<dynamic>? objects;

  EndPageInvent({
    Key? key,
    this.countObj,
    required this.listObj,
    this.time,
    this.objects,
  }) : super(key: key);

  @override
  _EndStatePageInvent createState() => _EndStatePageInvent(
      countObj: countObj, listObj: listObj, time: time, objects: objects);
}

class _EndStatePageInvent extends State<EndPageInvent> {
  MyUser? user;
  int? countObj;
  Map<String, dynamic> listObj;
  String? time;
  List<dynamic>? objects;

  _EndStatePageInvent(
      {this.countObj, required this.listObj, this.time, this.objects});

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Конец',
          style: TextStyle(
            fontSize: 21,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
              const Text(
                'Инвентаризация завершена!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
              const SizedBox(
                height: 20,
              ),
              ((listObj.isNotEmpty)
                  ? Text(
                      'К сожалению, в процессе проведения инвентаризации у вас выявилась недосдача. \nИз ${(countObj!).round()} инвентарных преметов, было недосчитано ${listObj.length} шт.\nВот их инвентарные номера (${listObj.keys.join(', ')})',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    )
                  : const Text(
                      'Все инвентарные объекты были найдены и отсканированны.',
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
                      msg: "Это может занять несколько секунд",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  final xls.Workbook workbook = xls.Workbook();

                  Excel.createExcel(user!, workbook, time!);
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

class Excel {
  static Future<void> createExcel(
      MyUser user, xls.Workbook workbook, String time) async {
    var getOrg = await FirebaseFirestore.instance
        .collection('userData')
        .doc(user.id)
        .get();

    var titles = [];
    List<int> bytes;

    Timer(const Duration(seconds: 2), () {
      titles.add(getOrg.data()!['data']['organization']);
    });

    var getNames = await FirebaseFirestore.instance
        .collection('userData')
        .doc(user.id)
        .collection("invents")
        .doc(time)
        .get();

    Timer(const Duration(seconds: 2), () {
      titles.add(getNames.data()!['names']);
      titles.add(getNames.data()!['timeStart']);
      titles.add(getNames.data()!['timeEnd']);
      titles.add(getNames.data()!['listObj']);
      titles.add(getNames.data()!['objects']);

      final xls.Worksheet sheet = workbook.worksheets[0];

      sheet.showGridlines = false;

      sheet.enableSheetCalculations();

      sheet.getRangeByName('A1').columnWidth = 6.82;
      sheet.getRangeByName('B1').columnWidth = 13.82;
      sheet.getRangeByName('C1').columnWidth = 11.82;
      sheet.getRangeByName('D1:E1').columnWidth = 10.20;
      sheet.getRangeByName('F1').columnWidth = 10;
      sheet.getRangeByName('F11').rowHeight = 50;
      sheet.getRangeByName('G1').columnWidth = 10.82;
      sheet.getRangeByName('H1').columnWidth = 9.10;

      final xls.Style globalStyle2 = workbook.styles.add('globalStyle2');
      globalStyle2.fontSize = 14;

      final xls.Style globalStyle1 = workbook.styles.add('globalStyle1');
      globalStyle1.fontSize = 14;
      globalStyle1.borders.bottom.lineStyle = xls.LineStyle.thin;
      globalStyle1.hAlign = xls.HAlignType.center;

      final xls.Style globalStyle3 = workbook.styles.add('globalStyle3');
      globalStyle3.fontSize = 12;
      globalStyle3.wrapText = true;
      globalStyle3.borders.all.lineStyle = xls.LineStyle.thin;
      globalStyle3.hAlign = xls.HAlignType.center;
      globalStyle3.vAlign = xls.VAlignType.center;

      final xls.Style titleStyle = workbook.styles.add('titleStyle');
      titleStyle.fontSize = 18;
      titleStyle.bold = true;
      titleStyle.hAlign = xls.HAlignType.center;

      sheet.getRangeByName('B4').setText('Учреждение:');
      sheet.getRangeByName('B5').setText('Ответственные лица:');
      sheet.getRangeByName('B7').setText('Дата проведение:');

      sheet.getRangeByName('C4').setText(titles[0]);

      List<String> list = titles[1].split(', ');
      if (list.length > 2) {
        sheet.getRangeByName('D5').setText(list[0] + ', ' + list[1] + ', ');
        for (int i = 2; i < list.length; i++) {
          sheet
              .getRangeByName('B6')
              .setText(list[i] + (((i + 1) < list.length) ? ', ' : ''));
        }
      } else {
        sheet.getRangeByName('D5').setText(titles[1]);
      }
      sheet.getRangeByName('D7').setText(titles[2] + ' - ' + titles[3]);

      sheet.getRangeByName('A2').setText('Акт инвентаризации');
      sheet.getRangeByName('A11').setText('Номер п/п');
      sheet.getRangeByName('B11').setText('Инвентарный номер');
      sheet.getRangeByName('C11').setText('Название объекта');
      sheet.getRangeByName('D11').setText('Локация');
      sheet.getRangeByName('E11').setText('Количество');
      sheet.getRangeByName('F12').setText('Сотрудник');
      sheet.getRangeByName('G12').setText('Дата');
      sheet.getRangeByName('F11').setText('Последнее редактирование');
      sheet.getRangeByName('H11').setText('Найдено штук');
      sheet.getRangeByName('A13').setText('1a');
      sheet.getRangeByName('B13').setText('1');
      sheet.getRangeByName('C13').setText('2');
      sheet.getRangeByName('D13').setText('3');
      sheet.getRangeByName('E13').setText('4');
      sheet.getRangeByName('F13').setText('5');
      sheet.getRangeByName('G13').setText('6');
      sheet.getRangeByName('H13').setText('7');

      sheet.getRangeByName('A2:H2').merge();
      sheet.getRangeByName('B5:C5').merge();
      sheet.getRangeByName('B7:C7').merge();
      sheet.getRangeByName('C4:G4').merge();
      sheet.getRangeByName('D5:G5').merge();
      sheet.getRangeByName('B6:G6').merge();
      sheet.getRangeByName('D7:G7').merge();
      sheet.getRangeByName('A11:A12').merge();
      sheet.getRangeByName('B11:B12').merge();
      sheet.getRangeByName('C11:C12').merge();
      sheet.getRangeByName('D11:D12').merge();
      sheet.getRangeByName('E11:E12').merge();
      sheet.getRangeByName('F11:G11').merge();
      sheet.getRangeByName('H11:H12').merge();

      sheet.getRangeByName('A2:H2').cellStyle = titleStyle;
      sheet.getRangeByName('C4:G4').cellStyle = globalStyle1;
      sheet.getRangeByName('D5:G5').cellStyle = globalStyle1;
      sheet.getRangeByName('B6:G6').cellStyle = globalStyle1;
      sheet.getRangeByName('D7:G7').cellStyle = globalStyle1;
      sheet.getRangeByName('B4:B5').cellStyle = globalStyle2;
      sheet.getRangeByName('B7').cellStyle = globalStyle2;
      sheet
          .getRangeByName('A11:H' + (titles[5].length + 13).toString())
          .cellStyle = globalStyle3;
      sheet.getRangeByName('B6').cellStyle.hAlign = xls.HAlignType.left;

      var countObj = 0;
      for (int i = 0; i < titles[5].length; i++) {
        var num = (i + 14).toString();
        sheet.getRangeByName('A' + num).setText((i + 1).toString());
        sheet.getRangeByName('B' + num).setText(titles[5][i]['number']);
        sheet.getRangeByName('C' + num).setText(titles[5][i]['object']);
        sheet.getRangeByName('D' + num).setText(titles[5][i]['map']);
        sheet.getRangeByName('E' + num).setText(titles[5][i]['count']);
        sheet.getRangeByName('F' + num).setText(titles[5][i]['name']);
        sheet.getRangeByName('G' + num).setText(titles[5][i]['time']);

        countObj += int.parse(titles[5][i]['count']);

        if (titles[4].containsKey(titles[5][i]['number'])) {
          sheet.getRangeByName('H' + num).setText(titles[4][titles[5][i]['number']].toString());
        } else {
          sheet.getRangeByName('H' + num).setText(titles[5][i]['count']);
          countObj -= int.parse(titles[5][i]['count']);
        }
      }

      Timer(Duration(seconds: 4), () async {
        var last = (14 + titles[5].length).toString();

        sheet.getRangeByName('G' + last + ':H' + last).cellStyle = globalStyle3;
        sheet.getRangeByName('G' + last).setText('Недостача');
        sheet.getRangeByName('G' + last).cellStyle.bold = true;
        sheet
            .getRangeByName('H' + last)
            .setText((countObj).toString());

        var last1 = (14 + titles[5].length + 4).toString();
        sheet.getRangeByName('F' + last1).setText('Подпись');
        sheet.getRangeByName('F' + last1).cellStyle = globalStyle2;
        sheet.getRangeByName('G' + last1 + ':H' + last1).merge();
        sheet.getRangeByName('G' + last1 + ':H' + last1).cellStyle =
            globalStyle1;
        bytes = workbook.saveAsStream();

        workbook.dispose();

        final String path = (await getApplicationSupportDirectory()).path;
        final String fileName = '$path/Output.xlsx';
        final File file = File(fileName);
        await file.writeAsBytes(bytes, flush: true);

        Timer(const Duration(seconds: 2), () {
          OpenFile.open(fileName);
        });
      });
    });
  }
}
