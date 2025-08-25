import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/app_color.dart';
import '../../../../core/widgets/glowing_gps.dart';
import '../../domain/entities/Suggestions.dart';
import '../bloc/suggestion_bloc.dart';
import '../pages/suggestion_details_page.dart';
import 'dart:math' as math;

class SuggestionsListWidget extends StatefulWidget {
  final List<Suggestions> suggestion;
  final bool isMySuggestionsPage;

  const SuggestionsListWidget({
    Key? key,
    required this.suggestion,
    required this.isMySuggestionsPage,
  }) : super(key: key);

  @override
  State<SuggestionsListWidget> createState() => _SuggestionsListWidgetState();
}

class _SuggestionsListWidgetState extends State<SuggestionsListWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        thickness: 0.3,
        color: AppColors.MidGreen,
        endIndent: 20,
        indent: 20,
        height: 20,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: widget.suggestion.length,
      itemBuilder: (context, index) {
        final suggestion = widget.suggestion[index];
        final animationDelay = Duration(milliseconds: 400);

        return Animate(
          effects: [
            FadeEffect(
              duration: const Duration(milliseconds: 400),
              delay: animationDelay,
              curve: Curves.easeOut,
            ),
            SlideEffect(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
              duration: const Duration(milliseconds: 400),
              delay: animationDelay,
              curve: Curves.easeOut,
            ),
            ScaleEffect(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1, 1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SuggestionCard(
              suggestion: suggestion,
              showIconButton: widget.isMySuggestionsPage,
            ),
          ),
        );
      },
    );
  }
}

class SuggestionCard extends StatefulWidget {
  final Suggestions suggestion;
  final bool showIconButton;

  const SuggestionCard({
    Key? key,
    required this.suggestion,
    required this.showIconButton,
  }) : super(key: key);

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> with SingleTickerProviderStateMixin {
  late AnimationController _voteController;
  late Animation<double> _likeAnimation;
  late Animation<double> _dislikeAnimation;

  @override
  void initState() {
    super.initState();
    _voteController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _likeAnimation = Tween<double>(begin: 0, end: widget.suggestion.likes.toDouble()).animate(
      CurvedAnimation(parent: _voteController, curve: Curves.easeOutCubic),
    );
    _dislikeAnimation = Tween<double>(begin: 0, end: widget.suggestion.dislikes.toDouble()).animate(
      CurvedAnimation(parent: _voteController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(covariant SuggestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.suggestion.likes != widget.suggestion.likes ||
        oldWidget.suggestion.dislikes != widget.suggestion.dislikes) {
      _likeAnimation = Tween<double>(
        begin: _likeAnimation.value,
        end: widget.suggestion.likes.toDouble(),
      ).animate(
        CurvedAnimation(parent: _voteController, curve: Curves.easeOutCubic),
      );
      _dislikeAnimation = Tween<double>(
        begin: _dislikeAnimation.value,
        end: widget.suggestion.dislikes.toDouble(),
      ).animate(
        CurvedAnimation(parent: _voteController, curve: Curves.easeOutCubic),
      );
      _voteController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _voteController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: const Text('تأكيد الحذف', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('هل أنت متأكد من حذف هذا المقترح؟'),
        actions: [
          TextButton(
            child: const Text('إلغاء', style: TextStyle(color: AppColors.MidGreen)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
            onPressed: () {
              context.read<SuggestionBloc>().add(
                DeleteMySuggestionEvent(widget.suggestion.id),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ).animate().fadeIn(duration: const Duration(milliseconds: 300)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suggestion = widget.suggestion;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuggestionDetailsPage(
                suggestion: widget.suggestion,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
            )]
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (Avatar + Name + Menu)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.MidGreen.withOpacity(0.2),
                    child: const Icon(Icons.person, color: AppColors.MidGreen),
                  ).animate().scale(duration: const Duration(milliseconds: 500)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              suggestion.user.createdBy,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              suggestion.createdat ?? 'غير محدد',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            GlowingGPSIcon(size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                suggestion.location.name ?? 'غير محدد',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Row(
                        //   children: [
                        //     const Icon(Icons.people_outline, size: 18, color: AppColors.CedarOlive),
                        //     const SizedBox(width: 6),
                        //     Text(
                        //       'المشاركون المطلوبون: ${suggestion.numberOfParticipants}',
                        //       style: Theme.of(context)
                        //           .textTheme
                        //           .labelMedium
                        //           ?.copyWith(color: Colors.grey[600]),
                        //       overflow: TextOverflow.ellipsis,
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  if (widget.showIconButton)
                    PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 8,
                      onSelected: (value) {
                        if (value == 'delete') _showDeleteConfirmationDialog();
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete_outline, color: Colors.red),
                              const SizedBox(width: 8),
                              const Text('حذف', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
                ],
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                suggestion.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
              const SizedBox(height: 12),
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: suggestion.imageUrl != null && suggestion.imageUrl!.isNotEmpty
                    ? Image.network(
                  suggestion.imageUrl!,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(height: 180, color: Colors.white),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image, size: 60, color: Colors.grey[400]),
                  ),
                ).animate().fadeIn(duration: const Duration(milliseconds: 600))
                    : Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Icon(Icons.image_not_supported, size: 60)),
                ),
              ),
              const SizedBox(height: 16),
              // Likes / Dislikes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedBuilder(
                    animation: _voteController,
                    builder: (context, _) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.thumb_up_outlined, color: Colors.green, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '(${_likeAnimation.value.round()})',
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ).animate().scale(duration: const Duration(milliseconds: 400)),
                  AnimatedBuilder(
                    animation: _voteController,
                    builder: (context, _) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.thumb_down_outlined, color: Colors.red, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '(${_dislikeAnimation.value.round()})',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ).animate().scale(duration: const Duration(milliseconds: 400)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}