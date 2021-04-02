import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SpinKitSquareCircle(
            color: Colors.black,
            size: 50,
          ),
          SizedBox(height: 10.0),
          Text("Chargement...", style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
