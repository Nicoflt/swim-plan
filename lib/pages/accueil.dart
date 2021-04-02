import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swimplan/pages/connexion/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Bienvenue !",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          toolbarHeight: 100,
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .snapshots(),
                      builder: (context, snapshot) {
                        return Text(snapshot.data.documents[0]
                            ['prenom']); //////////////
                      },
                    );
                  },
                  child: Text("Utilisateur actuellement connecté")),
              Text("Vous êtes connecté!"),
              OutlinedButton(
                child: Text("Se déconnecter",
                    style: TextStyle(color: Colors.black)),
                onPressed: () async {
                  if (FirebaseAuth.instance.currentUser != null) {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Connect()),
                    );
                    print(FirebaseAuth.instance.currentUser);
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
