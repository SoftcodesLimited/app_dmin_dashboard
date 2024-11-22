import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController searchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  bool isLoading = false;

  // Categorized search results
  Map<String, List<String>> searchResults = {
    "AppData": [],
    "Contacts": [],
    "Applications": [],
  };

  /// Displays the overlay
  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) _hideOverlay();
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      _isOverlayVisible = true;
    });
  }

  /// Hides the overlay
  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    setState(() {
      _isOverlayVisible = false;
    });
  }

  /// Creates the overlay with search results
  OverlayEntry _createOverlayEntry(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx - (size.width * 1.5 / 3),
        top: offset.dy + size.height + 5,
        width: size.width * 3,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.white10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(91, 0, 0, 0),
                  offset: Offset(5, 5),
                  blurRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Material(
                  color: const Color.fromARGB(193, 26, 29, 41),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: isLoading
                          ? [const Center(child: CircularProgressIndicator())]
                          : _buildSearchResults(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the search results UI
  List<Widget> _buildSearchResults() {
    final widgets = <Widget>[];

    searchResults.forEach((category, results) {
      if (results.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              category,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );

        widgets.addAll(results.map((result) {
          return ListTile(
            title: Text(result, style: const TextStyle(color: Colors.white)),
            onTap: () {
              _hideOverlay();
              // Handle item selection
            },
          );
        }).toList());
      }
    });

    return widgets.isEmpty
        ? [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No results found",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ]
        : widgets;
  }

  /// Handles search across multiple categories
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      searchResults = {
        "AppData": [],
        "Contacts": [],
        "Applications": [],
      };
    });

    await Future.wait([
      _searchAppData(query),
      _searchContacts(query),
      _searchApplications(query),
    ]);

    setState(() {
      isLoading = false;
    });
  }

  /// Fetches search results from Firestore for "AppData"
  Future<void> _searchAppData(String query) async {
    try {
      final db = FirebaseFirestore.instance;
      final snapshot = await db.collection('AppData').get();

      final results = snapshot.docs
          .map((doc) => doc.id)
          .where((id) => id.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        searchResults["AppData"] = results;
      });
    } catch (e) {
      print("Error searching AppData: $e");
    }
  }

  /// Simulates a contacts search
  Future<void> _searchContacts(String query) async {
    final mockContacts = ["Alice", "Bob", "Charlie", "David"];
    final results = mockContacts
        .where((contact) => contact.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      searchResults["Contacts"] = results;
    });
  }

  /// Simulates an applications search
  Future<void> _searchApplications(String query) async {
    final mockApplications = ["Calculator", "Calendar", "Camera", "Chrome"];
    final results = mockApplications
        .where((app) => app.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      searchResults["Applications"] = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: searchController,
      onChanged: (value) {
        if (value.isEmpty) {
          _hideOverlay();
        } else {
          _performSearch(value);
          _showOverlay(context);
        }
      },
      style: const TextStyle(color: Colors.white),
    );
  }
}
