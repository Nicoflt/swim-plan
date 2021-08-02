import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swimplan/pages/pages - accueil/profile.dart';
import 'package:swimplan/pages/accueil.dart';
import 'package:swimplan/pages/chargement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Get informations of the collection "Users" on Firebase
Future<void> userGet() {
  return FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: currentUser.email)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      userName = doc["prenom"];
      userSurname = doc["nom"];
      userEmail = doc["email"];
    });
  });
}

class Connect extends StatefulWidget {
  final Function changePage;
  Connect({this.changePage});

  @override
  _ConnectState createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  String email = '';
  String password = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF9C9AFF),
                  Color(0xFF5D4BFF),
                ],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  titleSection(),
                  signInSection(),
                  signInWithSection(),
                  signUpSection(),
                ],
              ),
            ),
          );
  }

  Widget titleSection() {
    return Container(
      child: Column(
        children: [
          Text(
            "Swim Plan",
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          Text(
            "Take time to move...",
            style: TextStyle(),
          ),
        ],
      ),
    );
  }

  Widget signInSection() {
    Future signInWithEmailAndPassword() async {
      setState(() {
        //loading = true;
      });
      try {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print("Cette adresse mail n'existe pas");
        } else if (e.code == 'wrong-password') {
          print('Le mot de passe ne correspond pas');
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [],
      ),
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'e-mail'),
            onChanged: (val) => email = val,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'mot de passe'),
            obscureText: true,
            onChanged: (val) => password = val,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              minimumSize: Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Text(
              'Se connecter',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onPressed: () async {
              signInWithEmailAndPassword();
              if (FirebaseAuth.instance.currentUser != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Menu()),
                );
              }
              userGet();
            },
          ),
        ],
      ),
    );
  }

  Widget signInWithSection() {
    Future<UserCredential> signInWithGoogle() async {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }

    return Container(
      margin: EdgeInsets.all(30),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF333333),
              minimumSize: Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'SE ',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                  TextSpan(
                      text: 'CONNECTER ',
                      style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                  TextSpan(
                      text: 'AVEC ',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                  TextSpan(
                      text: 'GOOGLE ',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ],
              ),
            ),
            onPressed: () async {
              signInWithGoogle();
              setState(() {
                //loading = true;
                if (FirebaseAuth.instance.currentUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Menu()),
                  );
                }
              });
              if (FirebaseAuth.instance.currentUser != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Menu()),
                );
              }
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF333333),
              minimumSize: Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Text(
              'SE CONNECTER AVEC FACEBOOK',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            onPressed: () async {
              // AJOUTER FONCTIONNALITE DE CONNEXION AVEC FACEBOOK
            },
          ),
        ],
      ),
    );
  }

  Widget signUpSection() {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              child: Text(
                "Mot de passe oublié?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Text("|",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 50)),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              child: InkWell(
                child: Text("S'inscrire",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  widget.changePage();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
