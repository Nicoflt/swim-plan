import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  final Function changePage;
  Register({this.changePage});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  String surname = '';
  String name = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    Future<void> addUser() {
      return users
          .add({
            'nom': surname,
            'prenom': name,
            'email': email,
            'motdepasse': password,
          })
          .then((value) => print("Utilisateur ajouté"))
          .catchError((error) => print(
              "Problème survenu lors de l'ajout d'un utilisateur: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                widget.changePage();
              },
            ),
            Text("Retour à la page de connexion"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFbeeff6),
          ),
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(10),

          /////////////////// DEBUT FORMULAIRE INSCRIPTION ////////////////////

          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Créez votre compte",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (val) => val.isEmpty ? 'Entrez un nom' : null,
                  onChanged: (val) => surname = val,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Prénom'),
                  validator: (val) => val.isEmpty ? 'Entrez un prénom' : null,
                  onChanged: (val) => name = val,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (val) =>
                      val.isEmpty ? 'Veuillez entrer une adresse mail' : null,
                  onChanged: (val) => email = val,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                  validator: (val) => val.length < 6
                      ? 'Veuillez entrer un mot de passe supérieur à 6 caractères'
                      : null,
                  onChanged: (val) => password = val,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Color(0xFF105660),
                    textColor: Colors.white,
                    child: Text("S'inscrire"),
                    onPressed: () async {
                      _register();
                      addUser();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState.validate()) {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
  }
}
