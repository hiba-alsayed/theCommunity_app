import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:graduation_project/features/complaints/domain/entites/complaint.dart';
import 'package:intl/intl.dart';

class ComplaintSummaryStats extends StatelessWidget {
  final ComplaintEntity complaint;

  const ComplaintSummaryStats({
    super.key,
    required this.complaint,
  });

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'غير محدد';
    }
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return 'تاريخ غير صالح';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildAnimatedStatCard(
              context: context,
              title: 'النقاط',
              count: complaint.points,
              icon: Icons.star_rate_rounded,
              color: Colors.amber,
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTextStatCard(
              context: context,
              title: 'المنطقة',
              text: complaint.region ?? 'غير محدد',
              icon: Icons.location_on_rounded,
              color: Colors.blueAccent,
            ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTextStatCard(
              context: context,
              title: 'تاريخ الإنشاء',
              text: _formatDate(complaint.createdAt.toString()),
              icon: Icons.calendar_today_rounded,
              color: Colors.purple.shade600,
            ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStatCard({
    required BuildContext context,
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: Animate(
                    effects: [
                      CustomEffect(
                        duration: 2000.ms,
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          final int currentCount = (value * count).round();
                          return FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "$currentCount",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                          );
                        },
                      ),
                    ],
                    child: const Text(""),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextStatCard({
    required BuildContext context,
    required String title,
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}