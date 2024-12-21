import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:machinetest21/model/usermodel.dart';
import 'package:machinetest21/view/search_sort.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var ageController = TextEditingController();

  final su = FirebaseFirestore.instance.collection("Users");

  Future<void> addUserDetails(UserModel userInfoMap, String id) async {
    log("Adding user details to Firestore with ID: $id");
    await su.doc(id).set(userInfoMap.toJson());
    log("User details added to Firestore.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Add User Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your age";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      ageController.text.isNotEmpty &&
                      phoneController.text.isNotEmpty) {
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    UserModel userInfo = UserModel(
                      name: nameController.text,
                      phone: phoneController.text,
                      age: int.parse(ageController.text),
                    );
                    addUserDetails(userInfo, id);
                  } else {
                    log("Please fill all fields before submitting.");
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Searchuser()));
                },
                child: const Text("Done"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
