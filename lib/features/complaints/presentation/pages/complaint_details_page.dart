import 'package:flutter/material.dart';
import 'package:graduation_project/core/app_color.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import '../../../../core pages/location_map_view_page.dart';
import '../../../../core/widgets/glowing_gps.dart';
import '../../../../core/widgets/snack_bar.dart';
import '../../../profile/presentation/pages/get_profile_by_userid_page.dart';
import '../../domain/entites/complaint.dart';
import 'image_gallery_viewer_page.dart';

class ComplaintDetailsPage extends StatefulWidget {
  final ComplaintEntity complaint;

  const ComplaintDetailsPage({super.key, required this.complaint});

  @override
  State<ComplaintDetailsPage> createState() => _ComplaintDetailsPageState();
}

class _ComplaintDetailsPageState extends State<ComplaintDetailsPage> {
  void _openMap(BuildContext context) {
    if (widget.complaint.location.latitude == null ||
        widget.complaint.location.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        buildGlassySnackBar(
          message: 'إحداثيات الموقع غير متوفرة',
          color: AppColors.CedarOlive, // Using AppColors for consistency
          context: context,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LocationMapPage(
              latitude: widget.complaint.location.latitude!,
              longitude: widget.complaint.location.longitude!,
              locationName: widget.complaint.location.name ?? 'موقع الشكوى',
            ),
      ),
    );
  }

  final Map<String, Map<String, dynamic>> statusIcons = {
    'منجزة': {
      'icon': Icons.check_circle_outline,
      'color': AppColors.SunsetOrange,
    },
    'انتظار': {'icon': Icons.schedule, 'color': Colors.amber.shade600},
    'يتم التنفيذ': {
      'icon': Icons.rocket_launch_outlined,
      'color': Colors.green.shade600,
    },
    'مرفوضة': {'icon': Icons.cancel, 'color': Colors.red},
  };

  @override
  Widget build(BuildContext context) {
    final complaint=widget.complaint;
    final complaintImageUrl =
        widget.complaint.complaintImages.isNotEmpty
            ? widget.complaint.complaintImages.first.url
            : null;

    final statusData =
        statusIcons[widget.complaint.status] ??
        {'icon': Icons.info, 'color': Colors.grey};

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (complaintImageUrl != null && complaintImageUrl.isNotEmpty)
                Container(
                  margin: const EdgeInsets.all(16),
                  height: 250,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        complaintImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, _) =>
                                const Center(child: Text("فشل تحميل الصورة")),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: LoadingWidget());
                        },
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  height: 250,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(child: Text('لا توجد صورة للشكوى')),
                ),
              // Title + Status
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.complaint.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusData['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusData['color'],
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusData['icon'],
                            size: 16,
                            color: statusData['color'],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.complaint.status,
                            style: TextStyle(
                              fontSize: 12,
                              color: statusData['color'],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // User info + date
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GetProfileByUserIdPage(
                              userId: widget.complaint.user.userid,
                              userName: widget.complaint.user.createdBy),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.person, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(" بواسطة: ${widget.complaint.user.createdBy}", // Assuming 'user' object has 'createdBy'
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(widget.complaint.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.complaint.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Location
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openMap(context),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الموقع',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              GlowingGPSIcon(),
                              const SizedBox(width: 4),
                              if (widget.complaint.location.name != null)
                                Expanded(
                                  child: Text(widget.complaint.location.name!),
                                ),
                              const SizedBox(width: 8),
                              Text(
                                '(اضغط لعرض الموقع على الخريطة)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (widget.complaint.location.latitude != null &&
                              widget.complaint.location.longitude != null)
                            LocationPreview(
                              latitude: widget.complaint.location.latitude!,
                              longitude: widget.complaint.location.longitude!,
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Stats for Complaint
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'النقاط',
                        widget.complaint.points.toString(),
                        Icons.star,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'المنطقة',
                        widget.complaint.region,
                        Icons.location_city,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'تاريخ الإنشاء',
                        _formatDate(widget.complaint.createdAt),
                        Icons.date_range,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Complaint Images
              if (widget.complaint.complaintImages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'صور الشكوى',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _imageGallery(
                            context,
                            widget.complaint.complaintImages,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (widget.complaint.complaintImages.isNotEmpty)
                const SizedBox(height: 24),

              // Achievement Images
              if (widget.complaint.achievementImages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'صور الإنجاز',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _imageGallery(
                            context,
                            widget.complaint.achievementImages,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (widget.complaint.achievementImages.isNotEmpty)
                const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 110,
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Icon(icon, size: 24, color: const Color(0xFF0172B2)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageGallery(BuildContext context, List<dynamic> imageList) {
    if (imageList.isEmpty) {
      return const SizedBox.shrink();
    }
    final imageUrls = imageList.map((img) => img.url as String).toList();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(imageUrls.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ImageGalleryViewerPage(
                      imageUrls: imageUrls,
                      initialIndex: index,
                    ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrls[index],
              height: 120,
              width: 120,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 120,
                    width: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const SizedBox(
                  height: 120,
                  width: 120,
                  child: Center(child: LoadingWidget()),
                );
              },
            ),
          ),
        );
      }),
    );
  }
  String _formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }
}
