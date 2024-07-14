import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../homePage.dart';

class QrMorePage extends StatelessWidget {
  List<dynamic>? qrData;
  final qrKey = GlobalKey();
  File? file;

  QrMorePage({this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR-Code',
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RepaintBoundary(
                  key: qrKey,
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const Text(
                          'INVENT',
                          style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        // QrImage(
                        //   //место где будет показан QR код
                        //   data: qrData!.last[0],
                        //   size: 300,
                        // ),
                        Text(
                          qrData!.last[0],
                          style: const TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 21.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text("Количество: ${qrData!.last[1]}",
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 20.0,
                ),
                MaterialButton(
                  color: Colors.green,
                  padding: const EdgeInsets.all(20.0),
                  onPressed: () async {
                    try {
                      RenderRepaintBoundary boundary = qrKey.currentContext!
                          .findRenderObject() as RenderRepaintBoundary;
                      //captures qr image
                      var image = await boundary.toImage();
                      ByteData? byteData =
                          await image.toByteData(format: ImageByteFormat.png);
                      Uint8List pngBytes = byteData!.buffer.asUint8List();
                      //app directory for storing images.
                      final appDir = await getApplicationDocumentsDirectory();
                      //current time
                      var datetime = DateTime.now();
                      //qr image file creation
                      file =
                          await File('${appDir.path}/$datetime.png').create();
                      //appending data
                      await file?.writeAsBytes(pngBytes);
                      //Shares QR image
                      await Share.shareFiles(
                        [file!.path],
                        mimeTypes: ["image/png"],
                        text: "Лови QR-код",
                      );
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: const Text(
                    "Сохранить QR-Code",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0)),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(15.0),
                  onPressed: () async {
                    if (qrData!.length > 1) {
                      qrData!.removeLast();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => QrMorePage(qrData: qrData)));
                    } else {
                      Fluttertoast.showToast(
                          msg: "Все данные добавлены",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MyHomePage()));
                    }
                  },
                  child: const Text(
                    'Далее',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
