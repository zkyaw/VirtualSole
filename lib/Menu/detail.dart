import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtualsole/Menu/web_try.dart';
import 'package:virtualsole/utils/firebase_keys_loader.dart';
import '../connectivity_checker.dart';

class DetailPage extends StatefulWidget {
  final String shoeID;
  final String shoeName;
  final String brand;
  final String type;
  final String description;
  final String imageURL;
  final CameraDescription? camera;
  String? authKey;
  String? objID;
  String? grpID;

  DetailPage({
    super.key,
    required this.shoeID,
    required this.shoeName,
    required this.brand,
    required this.type,
    required this.description,
    required this.imageURL,
    this.authKey,
    this.objID,
    this.grpID,
    this.camera,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _initializePageData();
    _checkIfFavorite();
    _updateRecentlyViewed();
  }

  Future<void> _initializePageData() async {
    try {
      final backendKeys = await FirebaseKeysLoader.fetchBackendKeys();

      setState(() {
        widget.authKey = backendKeys['authKey'] ?? widget.authKey;
        widget.grpID = backendKeys['grpID'] ?? widget.grpID;
      });

      DocumentSnapshot shoeDataSnapshot = await FirebaseFirestore.instance
          .collection('shoes')
          .doc(widget.shoeID)
          .get();

      if (shoeDataSnapshot.exists) {
        setState(() {
          widget.objID = shoeDataSnapshot['objID'] ?? widget.objID;
        });
      } else {
        print("No lens data found for this shoe.");
      }
    } catch (e) {
      print("Error initializing page data: $e");
    }
  }

  void _updateRecentlyViewed() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        CollectionReference recentlyViewedRef = FirebaseFirestore.instance
            .collection('recentlyViewed')
            .doc(user.uid)
            .collection('shoes');

        await recentlyViewedRef.add({
          'userID': user.uid,
          'shoeID': widget.shoeID,
          'shoeName': widget.shoeName,
          'brand': widget.brand,
          'type': widget.type,
          'description': widget.description,
          'imageURL': widget.imageURL,
          'timestamp': FieldValue.serverTimestamp(),
        });

        QuerySnapshot querySnapshot = await recentlyViewedRef
            .orderBy('timestamp', descending: true)
            .get();

        if (querySnapshot.docs.length > 6) {
          querySnapshot.docs.skip(6).forEach((doc) {
            recentlyViewedRef.doc(doc.id).delete();
          });
        }

        print("Recently viewed updated");
      } catch (e) {
        print("Error updating recently viewed: $e");
      }
    } else {
      print("User not authenticated");
    }
  }

  void _toggleFavorite() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentReference favoriteRef = FirebaseFirestore.instance
            .collection('favorites')
            .doc(user.uid)
            .collection('shoes')
            .doc(widget.shoeID);

        if (isFavorite) {
          await favoriteRef.delete();
          print("Favorite removed");
        } else {
          await favoriteRef.set({
            'shoeID': widget.shoeID,
            'shoeName': widget.shoeName,
            'brand': widget.brand,
            'type': widget.type,
            'description': widget.description,
            'imageURL': widget.imageURL,
            'grpID': widget.grpID,
            'objID': widget.objID,
            'authKey': widget.authKey,
            'timestamp': FieldValue.serverTimestamp(),
          });
          print("Favorite added");
        }

        setState(() {
          isFavorite = !isFavorite;
        });
      } catch (e) {
        print("Error toggling favorite: $e");
      }
    }
  }

  void _checkIfFavorite() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot favoriteSnapshot = await FirebaseFirestore.instance
            .collection('favorites')
            .doc(user.uid)
            .collection('shoes')
            .doc(widget.shoeID)
            .get();

        setState(() {
          isFavorite = favoriteSnapshot.exists;
        });
        print("Favorite status checked: $isFavorite");
      } catch (e) {
        print("Error checking favorite status: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Shoe Details"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _toggleFavorite,
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    widget.imageURL,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey,
                      child: const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.shoeName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Brand: ${widget.brand}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  "Type: ${widget.type}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Center(
                  child: widget.grpID == null ||
                          widget.objID == null ||
                          widget.authKey == null
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: const Icon(Icons.camera),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebTryPage(
                                  grpID: widget.grpID as String,
                                  objID: widget.objID as String,
                                  authKey: widget.authKey as String,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
