import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Searchuser extends StatefulWidget {
  const Searchuser({super.key});

  @override
  State<Searchuser> createState() => _SearchuserState();
}

class _SearchuserState extends State<Searchuser> {
  final TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> above60 = [];
  List<DocumentSnapshot> below60 = [];
  bool isSearching = false;

  // Firebase Firestore instance to search users
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to search user by phone or name
  void searchUser(String query) async {
    setState(() {
      isSearching = true;
    });

    try {
      // First, try to search by name
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      // If no results are found for name, try searching by phone number
      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await _firestore
            .collection('Users')
            .where('phone', isEqualTo: query)
            .get();
      }

      // Separate the users by age category
      List<DocumentSnapshot> above60List = [];
      List<DocumentSnapshot> below60List = [];

      for (var doc in querySnapshot.docs) {
        var user = doc.data() as Map<String, dynamic>;
        if (user['age'] >= 60) {
          above60List.add(doc);
        } else {
          below60List.add(doc);
        }
      }

      // Sort users by age within their categories
      above60List.sort((a, b) => (a.data() as Map<String, dynamic>)['age']
          .compareTo((b.data() as Map<String, dynamic>)['age']));
      below60List.sort((a, b) => (a.data() as Map<String, dynamic>)['age']
          .compareTo((b.data() as Map<String, dynamic>)['age']));

      setState(() {
        above60 = above60List;
        below60 = below60List;
        isSearching = false;
      });
    } catch (e) {
      setState(() {
        isSearching = false;
      });
      // Handle error (e.g., no internet connection)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Input Field
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search by Name or Phone",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  searchUser(query); // Call search when input changes
                } else {
                  setState(() {
                    above60.clear();
                    below60.clear(); // Clear results if query is empty
                  });
                }
              },
            ),
            const SizedBox(height: 20),

            // Show loading indicator while searching
            if (isSearching)
              const CircularProgressIndicator()
            else if (above60.isEmpty && below60.isEmpty)
              const Text("No results found")
            else
              Expanded(
                child: ListView(
                  children: [
                    // Show Above 60 users first
                    if (above60.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Above 60",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ...above60.map((doc) {
                      var user = doc.data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(user['name']),
                          subtitle: Text(
                              "Phone: ${user['phone']}, Age: ${user['age']}"),
                        ),
                      );
                    }).toList(),

                    // Show Below 60 users
                    if (below60.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Below 60",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ...below60.map((doc) {
                      var user = doc.data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(user['name']),
                          subtitle: Text(
                              "Phone: ${user['phone']}, Age: ${user['age']}"),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
