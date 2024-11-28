import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/services/database/database.dart';
import 'package:myapp/utils/debuglogs.dart';
import 'package:myapp/utils/search_result_tile.dart';

class SearchField extends StatefulWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController searchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  bool isOverlayVisible = false;
  bool isLoading = false;
  final FirestoreService db = FirestoreService();

  // Cached data for search
  Map<String, List<String>> cachedData = {
    "AppData": [],
    "Messages": [],
    "Settings": [],
  };

  // Search results categorized by type
  Map<String, List<String>> searchResults = {
    "AppData": [],
    "Messages": [],
    "Settings": [],
  };

  @override
  void initState() {
    super.initState();
    _initializeData(); // Load data at initialization
  }

  /// Fetches and caches data on initialization
  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([
      _fetchAppData(),
      _fetchMessages(),
      _fetchSettings(),
    ]);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchAppData() async {
    try {
      final snapshot = await db.appData.get();

      final results = snapshot.docs.map((doc) => doc.id).toList();

      setState(() {
        cachedData["AppData"] = results;
      });
    } catch (e) {
      debugLog(DebugLevel.error, 'Error Fetching app Data: $e');
    }
  }

  Future<void> _fetchMessages() async {
    try {
      final chatCollection = await db.chatRoom.get();
      final usernames =
          await Future.wait(chatCollection.docs.map((chatDoc) async {
        try {
          // Access the users collection via FirestoreService
          final userDoc = await db.users.doc(chatDoc.id).get();

          if (userDoc.exists) {
            // Cast userDoc.data() to Map<String, dynamic>
            final data = userDoc.data() as Map<String, dynamic>;
            return data['username'] as String? ?? 'Unknown User';
          }
          return 'Unknown User';
        } catch (e) {
          debugLog(DebugLevel.error, 'Error fetching username for chat: $e');
          return 'Error User';
        }
      }));

      setState(() {
        // Assuming "Messages" refers to the list of usernames
        cachedData["Messages"] = List<String>.from(usernames);
      });

      // Explicitly cast the list to List<String>
      setState(() {
        cachedData["Messages"] = List<String>.from(usernames);
      });
    } catch (e) {
      debugLog(DebugLevel.error, 'Error Fetching Messages: $e');
    }
  }

  Future<void> _fetchSettings() async {
    // Mock data for demonstration purposes
    final mockSettings = ["Profile", "Account", "Username", "Password"];
    setState(() {
      cachedData["Settings"] = mockSettings;
    });
  }

  /// Performs search on the locally cached data
  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = {
          "AppData": [],
          "Messages": [],
          "Settings": [],
        };
      });
      return;
    }

    setState(() {
      searchResults = cachedData.map((category, data) {
        final filteredResults = data
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return MapEntry(category, filteredResults);
      });
    });
  }

  /// Displays the overlay
  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) _hideOverlay();
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      isOverlayVisible = true;
    });
  }

  /// Hides the overlay
  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    setState(() {
      isOverlayVisible = false;
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
            height: MediaQuery.of(context).size.height * 0.7,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _buildSearchResults(),
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
    final widgets = <Widget>[
      const SizedBox(height: 20),
    ];

    Map<String, Map<String, dynamic>> uiDeets = {
      'AppData': {
        'icon': 'assets/icons/database.svg',
        'color': const Color.fromARGB(107, 118, 4, 128),
      },
      'Messages': {
        'icon': 'assets/icons/chat-search.svg',
        'color': Colors.blue[100],
      },
      'Settings': {
        'icon': 'assets/icons/search-settings.svg',
        'color': Colors.green[100],
      }
    };

    searchResults.forEach((category, results) {
      if (results.isNotEmpty) {
        Widget title = Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: uiDeets[category]?['color'],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(32, 0, 0, 0),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(0, 3),
                        )
                      ]),
                  child: SvgPicture.asset(
                    uiDeets[category]?['icon'],
                    height: 25,
                    width: 25,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );

        List<Widget> result = results.map((result) {
          return SearchResultTile(
            title: result,
            category: category,
            onTap: () {
              _hideOverlay();
              // Handle item selection
            },
          );
        }).toList();

        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(9, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [title, ...result],
            ),
          ),
        ));
      }
    });

    if (widgets.length == 1) {
      // No results found
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/no-results-icon.svg',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 10),
                const Text(
                  "No results found",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return [
      Center(
        // Center all the results vertically
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Align items horizontally
          children: widgets,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: searchController,
      onChanged: (value) {
        _performSearch(value);
        if (value.isNotEmpty) {
          _showOverlay(context);
        } else {
          _hideOverlay();
        }
      },
      style: const TextStyle(color: Colors.white),
    );
  }
}
