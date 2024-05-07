import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestFirebase extends StatelessWidget {
  const TestFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(onPressed: (){
            FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: 'lakshmi.acube@gmail.com', password: 'helana123');

          }, child: const Text('test f'))
        ),
      ),
    );
  }
}
