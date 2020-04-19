import 'package:flutter/material.dart';
import 'package:mobile_number/mobile_number.dart';

import 'package:clone_whats_app/firebase/aut_utils.dart' as auth;

// ignore: must_be_immutable
class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _number = TextEditingController();
  final TextEditingController _code = TextEditingController();

  bool _codeSent = false;
  String _errorMessage;

  String verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildBar(context),
            _buildUpperText(context),
            SizedBox(height: 50),
            _buildInputs(),
            Expanded(child: Container()),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: _forward,
              child: Text(
                "Next",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  _buildInputs() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _number,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.add, color: Colors.grey),
                labelText: "Phone number",
                errorText: _errorMessage,
              ),
              validator: (String val) {
                if (val.isEmpty)
                  return "enter phone numbre ";
                else if (_errorMessage != null && _errorMessage.isNotEmpty)
                  return _errorMessage;
                else
                  return null;
              },
            ),
            if (_codeSent)
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: TextFormField(
                  controller: _code,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.add, color: Colors.grey),
                    labelText: "Code",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpperText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "whats up will send you a code to varify your phone number  ",
            textAlign: TextAlign.center,
          ),
          FlatButton(
            onPressed: _getMyPhone,
            child: Text("get my phone",
                style: TextStyle(
                  color: Colors.lightBlue,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Text(
              "Enter your pasword please",
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_vert, size: 30),
        ),
      ],
    );
  }

  void _forward() async {
    if (_codeSent) {
      _signInWithCode(verificationId, _code.text);
    } else {
      _startPhoneVerification(_number.text);
    }
  }

  void _getMyPhone() async {
    String number = await MobileNumber.mobileNumber;
    _number.text = number;
  }

  void _startPhoneVerification(String phoneNumber) {
    _errorMessage = null;
    auth.sendCode(
      phoneNumber: phoneNumber,
      onCodeSent: () {
        setState(() {
          _codeSent = true;
        });
      },
      codeTimeOut: () {
        setState(() {
          _codeSent = false;
        });
      },
      onFailed: (String message) {
        _errorMessage = message;
        _formKey.currentState.validate();
      },
      onDone: () {
        Navigator.pushReplacementNamed(context, "/home");
      },
    );
  }

  void _signInWithCode(String verificationId, String code) {
    return auth.signInWithPhoneAndCode(
        phone: _number.text,
        code: code,
        onDone: () {
          Navigator.pushReplacementNamed(context, "/home");
        },
        onError: (val) {
          _errorMessage = val;
          _formKey.currentState.validate();
        });
  }
}
