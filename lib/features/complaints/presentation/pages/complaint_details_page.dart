import 'package:flutter/material.dart';
import '../../../suggestions/presentation/pages/location_map_view_page.dart';
import '../../domain/entites/complaint.dart';
import 'package:graduation_project/core/widgets/glowing_gps.dart';

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
        const SnackBar(content: Text('إحداثيات الموقع غير متوفرة')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationMapPage(
          latitude: widget.complaint.location.latitude!,
          longitude: widget.complaint.location.longitude!,
          locationName: widget.complaint.location.name ?? 'موقع الشكوى',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        title: Text(
          widget.complaint.title,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, 'الوصف:'),
                Text(
                  widget.complaint.description,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 16),
                _infoRow('الحالة:', widget.complaint.status),
                _infoRow('المنطقة:', widget.complaint.region),
                _infoRow('النقاط:', widget.complaint.points.toString()),
                _infoRow('التاريخ:', _formatDate(widget.complaint.createdAt)),

                if (widget.complaint.location.latitude != null &&
                    widget.complaint.location.longitude != null) ...[
                  const SizedBox(height: 24),
                  _buildLocationCard(),
                ],

                const SizedBox(height: 24),

                if (widget.complaint.complaintImages.isNotEmpty) ...[
                  _sectionTitle(context, 'صور الشكوى:'),
                  const SizedBox(height: 8),
                  _imageGallery(widget.complaint.complaintImages),
                  const SizedBox(height: 24),
                ],

                if (widget.complaint.achievementImages.isNotEmpty) ...[
                  _sectionTitle(context, 'صور الإنجاز:'),
                  const SizedBox(height: 8),
                  _imageGallery(widget.complaint.achievementImages),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
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
                    Expanded(child: Text(widget.complaint.location.name!)),
                  const SizedBox(width: 8),
                  Text(
                    '(اضغط لعرض الموقع على الخريطة)',
                    style: TextStyle(
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
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: const Color(0xFF1E88E5),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageGallery(List imageList) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: imageList.map((img) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            img.url,
            height: 120,
            width: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 120,
              width: 120,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }
}