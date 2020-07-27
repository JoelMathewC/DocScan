import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:opencv/opencv.dart';
import 'package:opencv/core/core.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner/Screens/PreviewScreen.dart';


class CropScreen extends StatefulWidget {
  String imgPath;
  CropScreen({this.imgPath});
  @override
  _CropScreenState createState() => _CropScreenState();
}



class _CropScreenState extends State<CropScreen> {

  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Image Preview'),
        actions: <Widget>[
          IconButton(
          icon:Icon(Icons.mode_edit),
            onPressed: (){
            _cropImage();
            //Cropped Picture has to be passed to opencv portion of code
            },
      ),
          IconButton(
            icon:Icon(Icons.offline_pin),
            onPressed: () async {
              Navigator.push(context,MaterialPageRoute(
                  builder: (context) => PreviewScreen(
                    imgPath: widget.imgPath,
                  )
              ));
              //Cropped Picture has to be passed to opencv portion of code
            },
          ),
        ],

      ),
      body:Center(
        child: Image.file(File(widget.imgPath),fit: BoxFit.cover,),
      )
    );
  }

  Future<Null> _cropImage() async{
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: widget.imgPath,
       );
    if(croppedImage != null)
      imageFile = croppedImage;
    setState(() {
      widget.imgPath = imageFile.path;
    });
  }
}
