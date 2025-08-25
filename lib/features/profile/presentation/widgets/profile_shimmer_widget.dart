import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar and name
            Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 150,
                  height: 24,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 16,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Contact info card
            _buildSectionShimmer(
              context,
              children: [
                _buildInfoRowShimmer(),
                _buildInfoRowShimmer(),
                _buildInfoRowShimmer(),
              ],
            ),
            const SizedBox(height: 16),
            // About section card
            _buildSectionShimmer(
              context,
              children: [
                _buildInfoRowShimmer(width: 100),
                _buildInfoRowShimmer(width: 100),
                const SizedBox(height: 12),
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.white,
                ),
                const SizedBox(height: 6),
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.white,
                ),
                const SizedBox(height: 6),
                Container(
                  height: 16,
                  width: 200,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Skills section
            _buildSectionShimmer(
              context,
              children: [
                _buildChipsShimmer(),
              ],
            ),
            const SizedBox(height: 16),
            // Fields section
            _buildSectionShimmer(
              context,
              children: [
                _buildChipsShimmer(),
              ],
            ),
            const SizedBox(height: 24),
            // Footer text
            Container(
              height: 14,
              width: 180,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionShimmer(BuildContext context,
      {required List<Widget> children}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 24,
              width: 150,
              color: Colors.white,
            ),
            const Divider(
              height: 24,
              thickness: 1,
              color: Colors.black12,
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRowShimmer({double? width}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 16,
              width: width ?? double.infinity,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipsShimmer() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(
        4,
            (index) => Container(
          height: 32,
          width: 80 + index * 10,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}