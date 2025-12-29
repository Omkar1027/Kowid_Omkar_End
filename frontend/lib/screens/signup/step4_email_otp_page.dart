import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/signup_model.dart';
import 'step5_password_page.dart';

class Step4EmailOtpPage extends StatelessWidget {
  final SignupData data;
  final otpController = TextEditingController();
  Step4EmailOtpPage({super.key, required this.data});

  Future<void> verifyEmail(BuildContext context) async {
    final url = Uri.parse('http://localhost:5000/api/users/verify-otp');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json", "Authorization": "Bearer ${data.token}"},
      body: jsonEncode({"phone": data.phone, "otp": otpController.text, "type": "email"}),
    );
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Step5PasswordPage(data: data)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("4/6: Email OTP")),
      body: Column(children: [
        TextField(controller: otpController, decoration: const InputDecoration(hintText: "Try 0000")),
        ElevatedButton(onPressed: () => verifyEmail(context), child: const Text("Verify Email"))
      ]),
    );
  }
}