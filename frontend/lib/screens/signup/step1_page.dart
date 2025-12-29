import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/signup_model.dart';
import 'step2_otp_page.dart';

class Step1Page extends StatefulWidget {
  const Step1Page({super.key});
  @override
  State<Step1Page> createState() => _Step1PageState();
}

class _Step1PageState extends State<Step1Page> {
  final fName = TextEditingController();
  final lName = TextEditingController();
  final phone = TextEditingController();

  Future<void> startSignup() async {
    final url = Uri.parse('http://localhost:5000/api/users/step1');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "firstName": fName.text,
          "lastName": lName.text,
          "phone": phone.text,
        }),
      );

      if (response.statusCode == 200) {
        SignupData data = SignupData(firstName: fName.text, lastName: lName.text, phone: phone.text);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Step2OtpPage(data: data)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("1/6: Info")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(controller: fName, decoration: const InputDecoration(labelText: "First Name")),
          TextField(controller: lName, decoration: const InputDecoration(labelText: "Last Name")),
          TextField(controller: phone, decoration: const InputDecoration(labelText: "Phone Number")),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: startSignup, child: const Text("Get OTP"))
        ]),
      ),
    );
  }
}