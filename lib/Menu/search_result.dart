import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail.dart';
import '../connectivity_checker.dart';

class SearchResultPage extends StatelessWidget {
  final String query;

  const SearchResultPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return ConnectivityChecker(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search Results for "$query"'),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('shoes').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No shoes found.'));
            }

            final queryLower = query.toLowerCase();
            final results = snapshot.data!.docs.where((doc) {
              final shoeNameLower = doc['shoeName'].toString().toLowerCase();
              return shoeNameLower.contains(queryLower);
            }).toList();

            if (results.isEmpty) {
              return const Center(child: Text('No shoes found.'));
            }

            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final shoe = results[index];
                return ListTile(
                  leading: Image.network(shoe['imageURL']),
                  title: Text(shoe['shoeName']),
                  subtitle: Text(shoe['brand']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          shoeID: shoe.id,
                          shoeName: shoe['shoeName'],
                          brand: shoe['brand'],
                          type: shoe['type'],
                          description: shoe['description'],
                          imageURL: shoe['imageURL'],
                          grpID: shoe['grpID'],
                          objID: shoe['objID'],
                          authKey: shoe['authKey'],
                          camera: null,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
