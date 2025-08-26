import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmerList extends StatelessWidget {
  const CategoryShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          // Title
          Container(
            height: 18,
            width: 150,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          _buildShimmerListTile(),
          ...List.generate(5, (index) => _buildShimmerListTile()),
        ],
      ),
    );
  }

  Widget _buildShimmerListTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 120,
            height: 16,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}