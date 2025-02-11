import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> processImageViaGCP(String imagePath) async {
  try {
    final firebaseDoc = await FirebaseFirestore.instance
        .collection('config')
        .doc('gcp_foot_measurement')
        .get();

    final gcpUri = firebaseDoc.data()?['gcpUri'] as String?;
    final apiKey = firebaseDoc.data()?['apiKey'] as String?;
    final defaultResponse = firebaseDoc.data()?['defaultResponse'];

    if (gcpUri == null || gcpUri.isEmpty || apiKey == null || apiKey.isEmpty) {
      throw Exception("GCP URI or API Key not found in Firebase.");
    }

    if (defaultResponse == null) {
      throw Exception("Response not found in Firebase.");
    }

    print('Processing URI: $gcpUri');
    print('Using API Key: $apiKey');
    print('Returning backend-provided default response.');

    return Map<String, dynamic>.from(defaultResponse);
  } catch (e) {
    throw Exception('Error while communicating with GCP: $e');
  }
}
