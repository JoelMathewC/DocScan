import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:opencv/core/imgproc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class PreviewScreen extends StatefulWidget{
  String imgPath;

  PreviewScreen({this.imgPath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState(path: imgPath);

}
class _PreviewScreenState extends State<PreviewScreen>{

  double val = 100;
  String path;
  _PreviewScreenState({this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Scanned Document'
        ),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child:Slider(
                min:100,
                max:150,
                divisions: 5,
                value: val,
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                onChanged: (value)  async {
                  dynamic res = await ImgProc.threshold(await File(widget.imgPath).readAsBytes(), value, 255, ImgProc.threshBinary);
                  //res =  await ImgProc.dilate(res,[2,2]);
                  final file = File(join((await getTemporaryDirectory()).path, '${DateTime.now()}.png'));
                  await file.writeAsBytes(res);
                   setState(()  {
                     val = value;
                     path = file.path;
                   });

                },
              )
            ),
            Expanded(
              flex: 2,
              child: Image.file(File(path)),

            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 60.0,
                color: Colors.black,
                child: Row(

                  children: <Widget>[
                    SizedBox(width:100.0),
                    IconButton(
                      icon: Icon(Icons.save_alt,color: Colors.white,),
                      onPressed: () async {
                        final PermissionHandler _permissionHandler = PermissionHandler();
                        var result = await _permissionHandler.requestPermissions([PermissionGroup.storage]);

                          GallerySaver.saveImage(path).then((bool S) {
                            setState(() {
                              print(S);
                            });
                          });

                      },
                    ),
                    SizedBox(width:170.0),
                  IconButton(
                    icon: Icon(Icons.share,color: Colors.white,),
                    onPressed: (){
                      getBytesFromFile().then((bytes){
                        Share.file('Share via', basename(path), bytes.buffer.asUint8List(),'image/path');
                      });
                    },
                  ),

              ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<ByteData> getBytesFromFile() async{
    Uint8List bytes = File(path).readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }
}