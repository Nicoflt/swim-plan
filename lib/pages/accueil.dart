import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swimplan/pages/connexion/sign_in.dart';

User currentUser = FirebaseAuth.instance.currentUser;
String userName;
String userSurname;
String userEmail;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Swim Plan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          //toolbarHeight: 100,
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {},
                  child: Text("Utilisateur actuellement connecté")),
              Text("Vous êtes connecté!"),
              OutlinedButton(
                child: Text("Se déconnecter",
                    style: TextStyle(color: Colors.black)),
                onPressed: () async {
                  if (currentUser != null) {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Connect()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
