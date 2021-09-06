import 'package:flutter/material.dart';
import 'package:swimplan/pages/accueil.dart';
import 'package:swimplan/pages/connexion/sign_in.dart';
import 'package:swimplan/pages/connexion/sign_up.dart';
import 'package:swimplan/pages/pages - accueil/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool affichePageConnexion = true;
  bool connected = false;

  void changePage() {
    setState(() => affichePageConnexion = !affichePageConnexion);
  }

  @override
  Widget build(BuildContext context) {
    /*if (affichePageConnexion) {
      return Connect(changePage: changePage);
    } else {
      return Register(changePage: changePage);
    }*/
    return Menu();
  }
}
