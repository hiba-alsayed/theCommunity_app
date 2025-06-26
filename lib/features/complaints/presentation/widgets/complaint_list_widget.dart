import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/app_color.dart';
import '../../../../core/widgets/glowing_gps.dart';
import '../../domain/entites/complaint.dart';
import '../pages/complaint_details_page.dart';


//list
class ComplaintListView extends StatefulWidget  {
  final List<ComplaintEntity> complaints;

  const ComplaintListView({super.key, required this.complaints});

  @override
  State<ComplaintListView> createState() => _ComplaintListViewState();
}

class _ComplaintListViewState extends State<ComplaintListView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: widget.complaints.length,
      itemBuilder: (context, index) {
        final complaint = widget.complaints[index];
        final animationDelay = Duration(milliseconds: 100 + index * 50);

        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                animationDelay.inMilliseconds / _animationController.duration!.inMilliseconds,
                1.0,
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                  animationDelay.inMilliseconds / _animationController.duration!.inMilliseconds,
                  1.0,
                  curve: Curves.easeOutCubic,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ComplaintCard(complaint: complaint),
            ),
          ),
        );
      },
    );
  }
}

//card
class ComplaintCard extends StatelessWidget {
  final ComplaintEntity complaint;

  const ComplaintCard({
    super.key,
    required this.complaint,
  });

  ComplaintStatus get _complaintStatus {
    switch (complaint.status) {
      case 'يتم التنفيذ':
        return ComplaintStatus.active;
      case 'منجزة':
        return ComplaintStatus.completed;
      case 'انتظار':
        return ComplaintStatus.waiting;
      case 'مرفوضة':
        return ComplaintStatus.rejected;
      default:
        return ComplaintStatus.unknown;
    }
  }
  Color getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.active:
        return Colors.green.shade600;
      case ComplaintStatus.completed:
        return AppColors.SunsetOrange;
      case ComplaintStatus.rejected:
        return Colors.red;
      case ComplaintStatus.waiting:
        return Colors.amber.shade600;;
      default:
        return Colors.grey.shade500;
    }
  }
  IconData getStatusIcon(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.active:
        return Icons.rocket_launch_outlined;
      case ComplaintStatus.completed:
        return Icons.check_circle_outline;
      case ComplaintStatus.rejected:
        return Icons.cancel;
      case ComplaintStatus.waiting:
        return Icons.schedule;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = (complaint.complaintImages != null && complaint.complaintImages.isNotEmpty)
        ?complaint.complaintImages[0].url
        : '';
    final statusColor = getStatusColor(_complaintStatus);
    final isCompleted = _complaintStatus == ComplaintStatus.completed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComplaintDetailsPage(complaint: complaint),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl != null ?
                  Image.network(
                    imageUrl!,
                    width: 100,
                    height: 120,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 100,
                          height: 120,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 120,
                      color: Colors.grey[200],
                      child: Icon(Icons.broken_image, size: 40, color: Colors.grey[400]),
                    ),
                  )
                      : Container(
                    width: 100,
                    height: 120,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, size: 40, color: Colors.grey[400]),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              complaint.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isCompleted)
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: 0.5 + (0.5 * value),
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: statusColor.withOpacity(0.4),
                                          blurRadius: 6 * value,
                                          spreadRadius: 2 * value,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          else
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        complaint.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    GlowingGPSIcon(),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        complaint.location.name ?? 'غير محدد',
                                        style: Theme.of(context).textTheme.labelMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                // Row(
                                //   children: [
                                //     Icon(Icons.people_outline, size: 16, color: Colors.grey),
                                //     const SizedBox(width: 6),
                                //     Text(
                                //       '${campaign.numberOfParticipants ?? 0}',
                                //       style: Theme.of(context).textTheme.labelMedium,
                                //     ),
                                //   ],
                                // ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month_outlined, size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(
                                        DateFormat('yyyy-MM-dd HH:mm').format(complaint.createdAt) ?? 'غير محدد',
                                      style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            avatar: Icon(
                              getStatusIcon(_complaintStatus),
                              size: 16,
                              color: statusColor,
                            ),
                            label: Text(
                              complaint.status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: statusColor.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: statusColor.withOpacity(0.3)),
                            ),
                            elevation: 4,
                            shadowColor: statusColor.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ],

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
enum ComplaintStatus { active, completed,rejected,waiting, unknown }