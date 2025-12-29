import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/signup_model.dart';
import 'step6_pin_page.dart';

class Step5PasswordPage extends StatelessWidget {
  final SignupData data;
  final pass = TextEditingController();
  Step5PasswordPage({super.key, required this.data});

  Future<void> savePassword(BuildContext context) async {
    final url = Uri.parse('http://localhost:5000/api/users/security');
    await http.post(
      url,
      headers: {"Content-Type": "application/json", "Authorization": "Bearer ${data.token}"},
      body: jsonEncode({"phone": data.phone, "type": "password", "value": pass.text}),
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => Step6PinPage(data: data)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("5/6: Password")),
      body: Column(children: [
        TextField(controller: pass, obscureText: true, decoration: const InputDecoration(labelText: "Set Password")),
        ElevatedButton(onPressed: () => savePassword(context), child: const Text("Next"))
      ]),
    );
  }
}