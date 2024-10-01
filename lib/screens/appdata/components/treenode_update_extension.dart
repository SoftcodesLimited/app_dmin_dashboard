import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/appdata/components/firestore_element.dart';
import 'package:myapp/utils/tree_widget/tree_view.dart';

extension Update<T> on TreeNode<T>  {
  void update(
    String value,
    String path,
    ValueNotifier<List<TreeNode<T>>> treeNotifier,
    ValueNotifier<bool> isUpdating,
  ) async {
    isUpdating.value = true;

    final parts = path.split('.');
    final documentPath = parts.first;
    final fieldPath = parts.sublist(1).join('.');

    final documentReference =
        FirebaseFirestore.instance.collection('AppData').doc(documentPath);
    debugPrint('Updating: $path');

    await documentReference.update({fieldPath: value}).then((_) {
      debugPrint('Firestore updated successfully.');

      // Update the local node data
      if (data is FirestoreElement) {
        final firestoreElement = data as FirestoreElement;
        firestoreElement.data = value;

        // Notify listeners after updating the tree structure
        treeNotifier.value = List<TreeNode<T>>.from(treeNotifier.value);
        debugPrint('UI updated with new value: $value');
        isUpdating.value = false;
      }
    }).catchError((error) {
      debugPrint('Failed to update: $error');
      isUpdating.value = false;
    });
  }
}