import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File> getImage(BuildContext context) {
  return showModalBottomSheet<File>(
      context: context,
      builder: (ctx) {
        return Container(
          height: 200,
          color: Colors.green[300],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Chose provider", style: Theme.of(context).textTheme.title),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: selector(0, (File e) {
                      Navigator.pop(context, e);
                    }),
                  ),
                  Expanded(
                    child: selector(1, (File e) {
                      Navigator.pop(context, e);
                    }),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}

Widget selector(int i, Function(File) onSubmit) {
  return GestureDetector(
    onTap: () {
      ImagePicker.pickImage(
        source: i == 0 ? ImageSource.camera : ImageSource.gallery,
      ).then((val) {
        onSubmit(val);
      });
    },
    child: CircleAvatar(
      radius: 50,
      child: Icon(i == 0 ? Icons.camera_alt : Icons.photo, size: 50),
    ),
  );
}
