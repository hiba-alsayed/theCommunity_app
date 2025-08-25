import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CampaignComplaintListShimmer extends StatelessWidget {
  const CampaignComplaintListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(14),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const CampaignCardShimmer();
      },
    );
  }
}
class CampaignCardShimmer extends StatelessWidget {
  const CampaignCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for the image
            Container(
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white, // Placeholder color
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder for the title
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  // Placeholder for the description
                  Container(
                    height: 15,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 15,
                    width: 150,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  // Placeholder for the icons and text
                  Row(
                    children: [
                      Container(
                        height: 16,
                        width: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 15,
                        width: 100,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        height: 16,
                        width: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 15,
                        width: 80,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
