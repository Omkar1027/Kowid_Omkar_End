import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/signup_model.dart';
import 'step4_email_otp_page.dart';
import 'step5_password_page.dart';

class Step3EmailPage extends StatelessWidget {
  final SignupData data;
  final emailController = TextEditingController();
  Step3EmailPage({super.key, required this.data});

  Future<void> saveEmail(BuildContext context) async {
    final url = Uri.parse('http://localhost:5000/api/users/save-email');
    await http.post(
      url,
      headers: {"Content-Type": "application/json", "Authorization": "Bearer ${data.token}"},
      body: jsonEncode({"phone": data.phone, "email": emailController.text}),
    );
    data.email = emailController.text;
    Navigator.push(context, MaterialPageRoute(builder: (context) => Step4EmailOtpPage(data: data)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("3/6: Email")),
      body: Column(children: [
        TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
        ElevatedButton(onPressed: () => saveEmail(context), child: const Text("Verify Email")),
        TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Step5PasswordPage(data: data))), child: const Text("Skip"))
      ]),
    );
  }
}