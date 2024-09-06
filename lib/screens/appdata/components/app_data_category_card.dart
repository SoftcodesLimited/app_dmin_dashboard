import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/screens/appdata/components/app_data_category_info.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/shimmer_container.dart';

class AppdataCategoryCard extends StatelessWidget {
  const AppdataCategoryCard({
    super.key,
    required this.info,
    required this.count,
  });

  final AppdataInfo info;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: info.icon.color.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SvgPicture.asset(
                  info.icon.iconAsset,
                  width: 35,
                  height: 35,
                  colorFilter: info.icon.applyColor
                      ? ColorFilter.mode(info.icon.color, BlendMode.srcIn)
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                info.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15),
              ),

              const SizedBox(width: 10),
              //const Icon(Icons.more_vert, color: Colors.white54)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: info.icon.color),
                      color: info.icon.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    'Edit',
                    style: TextStyle(fontSize: 15, color: info.icon.color),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}

class AppdataCategoryCardLoading extends StatelessWidget {
  const AppdataCategoryCardLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              ShimmerContainer(
                height: 40,
                width: 40,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              SizedBox(width: 10),
              ShimmerContainer(
                width: 100,
                height: 15,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              SizedBox(width: 10),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerContainer(
                  width: 90,
                  height: 30,
                  borderRadius: BorderRadius.circular(15)),
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
