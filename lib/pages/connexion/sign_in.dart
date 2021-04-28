import 'package:flutter/material.dart';
import 'package:swimplan/constants.dart';
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
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 20),
                titleSection(),
                signInSection(),
                signInWithSection(),
                SizedBox(height: 30),
                signUpSection(),
              ],
            ),
          );
  }

  Widget titleSection() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: FlutterLogo(size: 70),
          ),
          Text(
            "Swim Plan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: kTextColor,
            ),
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
        color: Color(0xFFbeeff6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 5,
            blurRadius: 5,
            offset: Offset(3, 3),
          ),
        ],
      ),
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            "Connexion à votre compte",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            onChanged: (val) => email = val,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
            onChanged: (val) => password = val,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color(0xFF105660)),
              child: Text('Se connecter'),
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
          )
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
      child: Column(
        children: [
          Text("Se connecter avec:",
              style: TextStyle(
                fontSize: 20,
              )),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Image.asset('assets/images/google.png'),
                  iconSize: 50,
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
                Image.asset('assets/images/facebook.png', height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget signUpSection() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Vous n'êtes pas encore enregistré? "),
          InkWell(
            child: Text("Cliquez ici!", style: TextStyle(color: Colors.blue)),
            onTap: () {
              widget.changePage();
            },
          ),
        ],
      ),
    );
  }
}
