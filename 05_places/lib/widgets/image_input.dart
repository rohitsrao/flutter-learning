import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput>{

  File? _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = File(imageFile?.path as String);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile?.path as String);
    final savedImage = await imageFile?.saveTo('${appDir.path}/${fileName}');
  }

  @override
  Widget build(BuildContext context) {
    return (
      Row(
        children: <Widget>[
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              )
            ),
            child: _storedImage != null 
              ? Image.file(
                  _storedImage as File,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
            alignment: Alignment.center,
          ),
          SizedBox(width: 10),
          Expanded(
            child: FlatButton.icon(
              icon: Icon(Icons.camera),
              label: Text('Take Picture'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _takePicture,
            ),
          ),
        ]
      )
    );
  }
}