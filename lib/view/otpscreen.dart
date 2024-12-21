import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machinetest21/home_Page.dart';

class Otpscreen extends StatefulWidget {
  const Otpscreen({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  var otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("we have sent an OTP to your phone.plz verify"),
            TextField(
              keyboardType: TextInputType.phone,
              controller: otpController,
              decoration: InputDecoration(
                  fillColor: Colors.grey.withOpacity(0.25),
                  filled: true,
                  hintText: "enter otp",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    final cred = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: otpController.text);
                    await FirebaseAuth.instance.signInWithCredential(cred);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  } catch (e) {
                    log(e.toString());
                  }
                },
                child: const Text("verify"))
          ],
        ),
      )),
    );
  }
}
