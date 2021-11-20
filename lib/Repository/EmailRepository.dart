
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
  final serviceId = 'service_5r447ad';
  final templateId = 'template_t5sc8vw';
  final userId = 'user_YaAfiW2ojkNrUZpY6iAnt';

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
        'to_email': email,
        'user_subject': subject,
        'user_message': message,
        'signature': signature,
      }
    }),
  );
  print('Email Response: ' + response.toString());
}