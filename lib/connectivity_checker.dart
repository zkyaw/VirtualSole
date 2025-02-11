import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ConnectivityChecker extends StatefulWidget {
  final Widget child;

  const ConnectivityChecker({Key? key, required this.child}) : super(key: key);

  @override
  _ConnectivityCheckerState createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  late StreamSubscription<ConnectivityResult> subscription;
  bool isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      if (!isDialogShowing) {
        _showNoInternetDialog();
      }
    } else {
      if (isDialogShowing) {
        Navigator.of(context, rootNavigator: true).pop();
        isDialogShowing = false;
      }
    }
  }

  void _showNoInternetDialog() {
    isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text("Please connect to the internet."),
          actions: [
            TextButton(
              onPressed: () {
                Connectivity().checkConnectivity().then((result) {
                  if (result == ConnectivityResult.none) {
                    _showNoInternetDialog();
                  } else {
                    Navigator.of(context, rootNavigator: true).pop();
                    isDialogShowing = false;
                  }
                });
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
