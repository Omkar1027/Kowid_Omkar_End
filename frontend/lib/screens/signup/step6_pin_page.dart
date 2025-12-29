import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/signup_model.dart';

class Step6PinPage extends StatelessWidget {
  final SignupData data;
  final pin = TextEditingController();
  Step6PinPage({super.key, required this.data});

  Future<void> finishSignup(BuildContext context) async {
    final urlSec = Uri.parse('http://localhost:5000/api/users/security');
    final urlFinal = Uri.parse('http://localhost:5000/api/users/finalize');

    // 1. Save Encrypted PIN
    await http.post(
      urlSec,
      headers: {"Content-Type": "application/json", "Authorization": "Bearer ${data.token}"},
      body: jsonEncode({"phone": data.phone, "type": "pin", "value": pin.text}),
    );

    // 2. Finalize Account (Move from Redis to Postgres)
    final response = await http.post(
      urlFinal,
      headers: {"Content-Type": "application/json", "Authorization": "Bearer ${data.token}"},
      body: jsonEncode({"phone": data.phone}),
    );

    if (response.statusCode == 201) {
      showDialog(context: context, builder: (c) => const AlertDialog(title: Text("Welcome! 🎉 Account Created.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("6/6: Create PIN")),
      body: Column(children: [
        TextField(controller: pin, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "4-Digit PIN")),
        ElevatedButton(onPressed: () => finishSignup(context), child: const Text("FINISH SIGNUP"))
      ]),
    );
  }
}