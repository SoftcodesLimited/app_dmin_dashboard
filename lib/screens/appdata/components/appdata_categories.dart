import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/app_data_category_card.dart';
import 'package:myapp/screens/appdata/components/app_data_category_info.dart';
import 'package:myapp/utils/responsive.dart';

import '../../../utils/constants.dart';

class Categories extends StatelessWidget {
  const Categories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Categories",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Add New"),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 5,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1 : 2,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  Future<QuerySnapshot> getCategories() async {
    final db = FirebaseFirestore.instance;
    return await db.collection('AppData').get();
  }

  int calculateCount(DocumentSnapshot doc) {
    // Ensure that doc.data() is not null
    final data = doc.data() as Map<String, dynamic>?;
    //print('${doc.id} : $data');

    // Count the number of fields in the document
    int fieldCount = data != null ? data.length : 0;

    

    // Total count is the sum of fields and subcollections
    return fieldCount ;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: getCategories(), // Fetch data using your getCategories method
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the data
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 8,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              return const  AppdataCategoryCardLoading();
            })
;        } else if (snapshot.hasError) {
          // Handle any errors that occur during fetching
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // Handle the case when there's no data
          return const Center(child: Text('No data available'));
        } else {
          // Once the data is fetched, build the GridView
          final List<DocumentSnapshot> docs = snapshot.data!.docs;

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              final docData = docs[index];
              final count = calculateCount(docData); // Calculate count here

              return AppdataCategoryCard(
                info: AppdataInfo.fromDoc(docData),
                count: count, // Pass count to the card
              );
            },
          );
        }
      },
    );
  }
}
