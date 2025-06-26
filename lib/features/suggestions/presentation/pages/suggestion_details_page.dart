import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import 'package:graduation_project/features/suggestions/domain/entities/Suggestions.dart';
import '../../../../core/widgets/glowing_gps.dart';
import '../bloc/suggestion_bloc.dart';
import '../widgets/vote_widget.dart';
import '../../../../core pages/location_map_view_page.dart';

class SuggestionDetailsPage extends StatefulWidget {
  final Suggestions suggestion;
  final bool isMySuggestions;
  const SuggestionDetailsPage({
    super.key,
    required this.suggestion,
    this.isMySuggestions = false,
  });

  @override
  State<SuggestionDetailsPage> createState() => _SuggestionDetailsPageState();
}

class _SuggestionDetailsPageState extends State<SuggestionDetailsPage> {
  void _openMap(BuildContext context) {
    if (widget.suggestion.location.latitude == null ||
        widget.suggestion.location.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('إحداثيات الموقع غير متوفرة')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LocationMapPage(
              latitude: widget.suggestion.location.latitude!,
              longitude: widget.suggestion.location.longitude!,
              locationName: widget.suggestion.location.name ?? 'موقع المقترح',
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.suggestion.imageUrl;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null && imageUrl.isNotEmpty)
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
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, _) =>
                                Center(child: Text("فشل تحميل الصورة")),
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
                              color: Colors.white.withOpacity(0.4),
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
                  child: const Center(child: Text('لا توجد صورة')),
                ),

              // User info + date
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.suggestion.user.createdBy,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.suggestion.createdat,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Title +category
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.suggestion.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          widget.suggestion.category,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.suggestion.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
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
                          const SizedBox(height:10),
                          Row(
                            children: [
                              GlowingGPSIcon(),
                              const SizedBox(width:4),
                              if (widget.suggestion.location.name != null)
                                Text(widget.suggestion.location.name!),
                              const SizedBox(width: 8),
                              Text(
                                '(اضغط لعرض الموقع على الخريطة)',
                                style: TextStyle(
                                  color:Colors.grey[600],
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (widget.suggestion.location.latitude != null &&
                              widget.suggestion.location.longitude != null)
                            LocationPreview(
                              latitude: widget.suggestion.location.latitude!,
                              longitude: widget.suggestion.location.longitude!,
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'إجمالي التصويتات',
                        widget.suggestion.likes.toString(),
                        Icons.how_to_vote,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'المشاركون',
                        widget.suggestion.numberOfParticipants.toString(),
                        Icons.people,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'المبلغ المطلوب',
                        widget.suggestion.requiredAmount,
                        Icons.attach_money,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Voting
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
                          'ما رأيك في هذا المقترح؟',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        BlocConsumer<SuggestionBloc, SuggestionState>(
                          listener: (context, state) {
                            if (state is VoteOnSuggestionSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم التصويت بنجاح'),
                                ),
                              );
                            } else if (state is VoteOnSuggestionFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            }
                          },
                          builder: (context, state) {
                            final currentSuggestion =
                                (state is VoteOnSuggestionSuccess)
                                    ? state.updatedSuggestion
                                    : widget.suggestion;
                            return VotingSlider(suggestion: currentSuggestion);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 24, color: Color(0xFF0172B2)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
