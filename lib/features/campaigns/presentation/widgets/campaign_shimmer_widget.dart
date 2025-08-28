import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
class CampaignDetailsShimmer extends StatelessWidget {
  const CampaignDetailsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Title Placeholder
            Container(
              height: 18,
              width: 200,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            // Category Placeholder
            Container(
              height: 12,
              width: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // Progress Bar Placeholder
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 16,
              width: 150,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // User Info Placeholder
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Container(
                  height: 14,
                  width: 120,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Description Placeholder
            Container(
              height: 15,
              width: double.infinity,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Container(
              height: 15,
              width: 250,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}