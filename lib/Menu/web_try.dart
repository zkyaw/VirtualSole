import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WebTryPage extends StatelessWidget {
  final GlobalKey webViewKey = GlobalKey();
  final String authKey;
  final String objID;
  final String grpID;

  WebTryPage({
    super.key,
    required this.authKey,
    required this.objID,
    required this.grpID,
  });

  Future<String> fetchWebUriFromFirebase() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('web_try')
          .get();

      final webUri = doc.data()?['webUri'] as String?;

      if (webUri == null || webUri.isEmpty) {
        throw Exception("Web URI not found in Firebase.");
      }

      return "$webUri?auth=$authKey&obj=$objID&grp=$grpID";
    } catch (e) {
      throw Exception("Error fetching Web URI: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Try-On"),
      ),
      body: FutureBuilder<String>(
        future: fetchWebUriFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final webUri = snapshot.data!;

          return InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(webUri)),
            initialSettings: InAppWebViewSettings(
              isInspectable: false,
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              iframeAllow: "camera; microphone",
              iframeAllowFullscreen: true,
            ),
            onPermissionRequest: (controller, request) async {
              return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT,
              );
            },
          );
        },
      ),
    );
  }
}
