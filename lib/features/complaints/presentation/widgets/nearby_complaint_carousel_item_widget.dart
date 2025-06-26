import 'package:flutter/material.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import 'package:graduation_project/features/complaints/domain/entites/complaint.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/glowing_gps.dart';
import '../pages/complaint_details_page.dart';

class NearbyComplaintCarouselItemWidget  extends StatefulWidget {
  final ComplaintEntity complaint;

  const NearbyComplaintCarouselItemWidget({
    super.key,
    required this.complaint,
  });

  @override
  State<NearbyComplaintCarouselItemWidget> createState() => _NearbyComplaintCarouselItemWidgetState();
}

class _NearbyComplaintCarouselItemWidgetState extends State<NearbyComplaintCarouselItemWidget> {
  @override
  Widget build(BuildContext context) {
    final String imageUrl = (widget.complaint.complaintImages != null && widget.complaint.complaintImages.isNotEmpty)
        ? widget.complaint.complaintImages[0].url
        : '';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ComplaintDetailsPage(complaint: widget.complaint),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child:Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                  ),
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: LoadingWidget(),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.complaint.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          widget.complaint.category,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          DateFormat('yyyy-MM-dd HH:mm').format(widget.complaint.createdAt),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        GlowingGPSIcon(),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.complaint.location.name.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
