import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseKeysLoader {
  static Future<Map<String, dynamic>> fetchBackendKeys() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('gcp_backend')
          .get();

      if (!doc.exists) {
        throw Exception("GCP Backend config not found in Firestore.");
      }

      final data = doc.data() ?? {};
      final jsonUrl = data['credentialsJsonUrl'];

      if (jsonUrl != null) {
        final response = await http.get(Uri.parse(jsonUrl));
        if (response.statusCode == 200) {
          final jsonCredentials = jsonDecode(response.body);
          return {...data, 'gcpCredentials': jsonCredentials};
        } else {
          throw Exception("Failed to fetch GCP JSON credentials from $jsonUrl");
        }
      }

      return data;
    } catch (e) {
      throw Exception("Key retrieval failed: $e");
    }
  }
}
