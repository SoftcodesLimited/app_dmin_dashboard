
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchResultTile extends StatefulWidget {
  final String title;
  final String category;
  final void Function()? onTap;

  const SearchResultTile(
      {super.key, required this.title, this.onTap, required this.category});

  @override
  State<SearchResultTile> createState() => _SearchResultTileState();
}

class _SearchResultTileState extends State<SearchResultTile> {
  bool isHovered = false;

  String getIcon(String title) {
    switch (title) {
      case 'products':
        return 'assets/icons/products.svg';
      case 'Account' || 'Profile':
        return 'assets/icons/search-account.svg';
      case 'Internship':
        return 'assets/icons/intern.svg';
      case 'skilling':
        return 'assets/icons/skill.svg';
      case 'slider':
        return 'assets/icons/slider.svg';
      case 'HostingPackage':
        return 'assets/icons/hosting.svg';
      case 'bestDeals':
        return 'assets/icons/deals.svg';
      case 'feeds':
        return 'assets/icons/feeds.svg';
      case 'graphicsCards':
        return 'assets/icons/graphicsCard.svg';

      default:
        return 'assets/icons/search-result.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 100),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isHovered
                  ? const Color.fromARGB(80, 255, 255, 255).withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: SizedBox(
              width: 400,
              child: Row(
                children: [
                  SvgPicture.asset(
                    getIcon(widget.title),
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.title),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
