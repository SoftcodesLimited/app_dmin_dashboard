
import 'package:flutter/material.dart';
import 'package:myapp/utils/shimmer_container.dart';

class TreeLoadingWidget extends StatelessWidget {
  const TreeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerContainer(
                height: 15,
                width: 15,
                borderRadius: BorderRadius.circular(2),
              ),
              const SizedBox(
                width: 10,
              ),
              ShimmerContainer(
                height: 10,
                width: 150,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              ShimmerContainer(
                height: 15,
                width: 15,
                borderRadius: BorderRadius.circular(2),
              ),
              const SizedBox(
                width: 10,
              ),
              ShimmerContainer(
                height: 10,
                width: 120,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              ShimmerContainer(
                height: 15,
                width: 15,
                borderRadius: BorderRadius.circular(2),
              ),
              const SizedBox(
                width: 10,
              ),
              ShimmerContainer(
                height: 10,
                width: 120,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          )
        ],
      ),
    );
  }
}
