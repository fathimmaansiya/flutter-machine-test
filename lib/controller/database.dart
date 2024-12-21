import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:machinetest21/home_Page.dart';
import 'package:machinetest21/usermodel.dart';

class Database {
  final su = FirebaseFirestore.instance.collection("Users");
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      GoogleSignInAccount? user = await googleSignIn.signIn();
      if (user != null) {
        GoogleSignInAuthentication googleAuth = await user.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        // Sign in with the credential to Firebase
        await auth.signInWithCredential(credential);
      }
    } catch (e) {
      // Close the loading dialog
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in: ${e.toString()}')),
      );
      log('$e');
    } finally {
      // Ensure loading dialog is closed
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  // Future<void> addUserDetails(UserModel userInfoMap, String id) async {
  //   log("Adding user details to Firestore with ID: $id");
  //   await su.doc(id).set(userInfoMap.tojson());
  //   log("User details added to Firestore.");
  // }

  // void addUser(UserModel user) async {
  //   await FirebaseFirestore.instance.collection('users').add(user.toMap());
  // }

  // void searchUser(String query) async {
  //   var usersRef = FirebaseFirestore.instance.collection('users');
  //   var results = await usersRef
  //       .where('name', isGreaterThanOrEqualTo: query)
  //       .where('name', isLessThanOrEqualTo: query + '\uf8ff')
  //       .get();

  //   results.docs.forEach((doc) {
  //     print(doc.data()); // Display or handle results
  //   });
  // }

  // void fetchAndSortUsers() async {
  //   var usersRef = FirebaseFirestore.instance.collection('users');
  //   var snapshot = await usersRef.get();

  //   List<UserModel> users =
  //       snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();

  //   // Sorting users into two groups
  //   List<UserModel> above60 = users.where((user) => user.age > 60).toList();
  //   List<UserModel> below60 = users.where((user) => user.age <= 60).toList();

  //   above60.sort((a, b) => a.age.compareTo(b.age));
  //   below60.sort((a, b) => a.age.compareTo(b.age));

  //   // Combine both lists in the required order
  //   List<UserModel> sortedUsers = [...above60, ...below60];

  //   print(sortedUsers); // Handle sorted users here
  // }
}
