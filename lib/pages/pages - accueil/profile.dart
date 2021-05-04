import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swimplan/pages/connexion/sign_in.dart';

User currentUser = FirebaseAuth.instance.currentUser;
String userName;
String userSurname;
String userEmail;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {},
              child: Text("Utilisateur actuellement connecté")),
          Text(userName + " est connecté!"),
          OutlinedButton(
            child:
                Text("Se déconnecter", style: TextStyle(color: Colors.black)),
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
    );
  }
}
