
import 'dart:convert';

import 'package:http/http.dart';

Future sendEmail({
  String username,
  String name,
  String email,
  String subject,
  String message,
  String signature,
}) async {
  final serviceId = 'service_p7ttfeb';
  final templateId = 'template_f06muzc';
  final userId = 'user_6eJdSk843F0gUaNgpKkzw';

  final uri = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await post(
    uri,
    headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json'
    },
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': username,
        'user_email': 'rajuraj987@yahoo.com',
        'to_email': email,
        'user_subject': subject,
        'user_message': message,
        'signature': signature,
      }
    }),
  );
  print('Email Response: ' + response.toString());
}