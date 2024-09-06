import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum AppdataIcon {
  internship(
      name: 'Internship',
      color: Colors.orange,
      iconAsset: 'assets/icons/intern.svg',
      applyColor: true),
  bestDeals(
      name: 'bestDeals',
      color: Colors.red,
      iconAsset: 'assets/icons/deals.svg',
      applyColor: false),
  feeds(
      name: 'feeds',
      color: Colors.purple,
      iconAsset: 'assets/icons/feeds.svg',
      applyColor: true),
  graphicsCards(
      name: 'graphicsCards',
      color: Colors.pink,
      iconAsset: 'assets/icons/graphicsCard.svg',
      applyColor: true),
  products(
      name: 'products',
      color: Color.fromARGB(255, 202, 162, 162),
      iconAsset: 'assets/icons/products.svg',
      applyColor: false),
  skilling(
      name: 'skilling',
      color: Colors.teal,
      iconAsset: 'assets/icons/skill.svg',
      applyColor: false),
  slider(
      name: 'slider',
      color: Colors.green,
      iconAsset: 'assets/icons/slider.svg',
      applyColor: true),
  hostingPackage(
      name: 'HostingPackage',
      color: Colors.blue,
      iconAsset: 'assets/icons/hosting.svg',
      applyColor: true);

  final String name;
  final Color color;
  final String iconAsset;
  final bool applyColor;

  const AppdataIcon(
      {required this.name,
      required this.color,
      required this.iconAsset,
      required this.applyColor});
}

AppdataIcon getIcon(String title) {
  switch (title) {
    case 'HostingPackage':
      return AppdataIcon.hostingPackage;
    case 'Internship':
      return AppdataIcon.internship;
    case 'bestDeals':
      return AppdataIcon.bestDeals;
    case 'feeds':
      return AppdataIcon.feeds;
    case 'graphicsCards':
      return AppdataIcon.graphicsCards;
    case 'products':
      return AppdataIcon.products;
    case 'skilling':
      return AppdataIcon.skilling;
    case 'slider':
      return AppdataIcon.slider;

    default:
      return AppdataIcon.internship;
  }
}

class AppdataInfo {
  final String title;
  final AppdataIcon icon;

  late DocumentSnapshot document;

  AppdataInfo({
    required this.title,
    required this.icon,
  });

  factory AppdataInfo.fromDoc(DocumentSnapshot doc) {
    return AppdataInfo(title: doc.id, icon: getIcon(doc.id));
  }
}
