import 'package:flutter/material.dart';

void alert(
    {@required BuildContext context,
    String title,
    Widget content,
    Function onOk,
    Function onCancel}) {
  assert(context != null);
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title ?? "Alert"),
          content: content,
          actions: <Widget>[
            FlatButton(
              child: Text("cancel"),
              onPressed: () {
                if (onCancel != null) onCancel();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                if (onOk != null) onOk();
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
