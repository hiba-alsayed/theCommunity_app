import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/widgets/glowing_gps.dart';
import '../../domain/entities/Suggestions.dart';
import '../bloc/suggestion_bloc.dart';
import '../pages/suggestion_details_page.dart';
import 'dart:math' as math;

class SuggestionsListWidget extends StatefulWidget {
  final List<Suggestions> suggestion;
  final bool isMySuggestionsPage;
  const SuggestionsListWidget({
    super.key,
    required this.suggestion,
    required this.isMySuggestionsPage,
  });

  @override
  State<SuggestionsListWidget> createState() => _SuggestionsListWidgetState();
}

class _SuggestionsListWidgetState extends State<SuggestionsListWidget> {
  final ScrollController _scrollController = ScrollController();
  int _visibleItemCount = 5;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _visibleItemCount < widget.suggestion.length) {
      setState(() {
        _isLoadingMore = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _visibleItemCount = (_visibleItemCount + 5).clamp(
            0,
            widget.suggestion.length,
          );
          _isLoadingMore = false;
        });
      });
    }
  }

  @override
  void didUpdateWidget(covariant SuggestionsListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.suggestion != widget.suggestion) {
      _visibleItemCount = 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsToShow = widget.suggestion.take(_visibleItemCount).toList();

    return ListView.builder(
      controller: _scrollController,
      itemCount: itemsToShow.length + 1,
      itemBuilder: (context, index) {
        if (index < itemsToShow.length) {
          return SuggestionCard(
            suggestion: itemsToShow[index],
            showIconButton: widget.isMySuggestionsPage,
          );
        } else {
          if (_visibleItemCount >= widget.suggestion.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'لا توجد مقترحات إضافية',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: SpinKitChasingDots(
                        color: Color(0xFF0172B2),
                        size: 40.0,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'جارٍ تحميل المزيد...',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}



class SuggestionCard extends StatefulWidget {
  final Suggestions suggestion;
  final bool showIconButton;

  const SuggestionCard({
    super.key,
    required this.suggestion,
    required this.showIconButton,
  });

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا المقترح؟'),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              context.read<SuggestionBloc>().add(
                DeleteMySuggestionEvent(widget.suggestion.id),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(14),
        shadowColor: Colors.black26,
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
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
          onLongPress:
          widget.showIconButton ? _showDeleteConfirmationDialog : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: width * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                      NetworkImage(widget.suggestion.user.userimage),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.suggestion.user.createdBy,
                          style: TextStyle(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            GlowingGPSIcon(),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.suggestion.location.name}',
                              style: TextStyle(
                                fontSize: width * 0.03,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.suggestion.createdat}',
                          style: TextStyle(
                            fontSize: width * 0.03,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Transform.rotate(
                      angle: math.pi,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: const Color(0xFF00B4D8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.suggestion.description,
                    style: TextStyle(
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fade(duration: 350.ms).slideY(begin: 0.2, curve: Curves.easeOut),
    );
  }
}


