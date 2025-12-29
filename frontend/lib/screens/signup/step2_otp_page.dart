import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/signup_model.dart';
import 'step3_email_page.dart';

class Step2OtpPage extends StatelessWidget {
  final SignupData data;
  final otpController = TextEditingController();
  Step2OtpPage({super.key, required this.data});

  Future<void> verifyPhone(BuildContext context) async {
    final url = Uri.parse('http://localhost:5000/api/users/verify-otp');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": data.phone, "otp": otpController.text, "type": "phone"}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      data.token = body['token']; // Save the JWT token to the suitcase
      Navigator.push(context, MaterialPageRoute(builder: (context) => Step3EmailPage(data: data)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("2/6: Verify Phone")),
      body: Column(children: [
        Text("Enter OTP for ${data.phone}"),
        TextField(controller: otpController, decoration: const InputDecoration(hintText: "Try 0000")),
        ElevatedButton(onPressed: () => verifyPhone(context), child: const Text("Verify"))
      ]),
    );
  }
}