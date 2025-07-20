import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    return ListView.separated(
      separatorBuilder: (context,index) => Divider(thickness: 0.5,color: AppColors.MidGreen,endIndent: 16,indent: 16),
      padding: const EdgeInsets.all(14),
      itemCount: widget.suggestion.length,
      itemBuilder: (context, index) {
        final suggestion = widget.suggestion[index];
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
              child: SuggestionCard(
                suggestion: suggestion,
                showIconButton: widget.isMySuggestionsPage,
              ),
            ),
          ),
        );
      },
    );
  }
}

// class SuggestionCard extends StatefulWidget {
//   final Suggestions suggestion;
//   final bool showIconButton;
//
//   const SuggestionCard({
//     Key? key, // Added Key
//     required this.suggestion,
//     required this.showIconButton,
//   }) : super(key: key);
//
//   @override
//   State<SuggestionCard> createState() => _SuggestionCardState();
// }
// class _SuggestionCardState extends State<SuggestionCard> {
//   void _showDeleteConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('تأكيد الحذف'),
//         content: const Text('هل أنت متأكد من حذف هذا المقترح؟'),
//         actions: [
//           TextButton(
//             child: const Text('إلغاء'),
//             onPressed: () => Navigator.pop(context),
//           ),
//           TextButton(
//             child: const Text(
//               'حذف',
//               style: TextStyle(color: Colors.red),
//             ),
//             onPressed: () {
//               context.read<SuggestionBloc>().add(
//                 DeleteMySuggestionEvent(widget.suggestion.id),
//               );
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.easeInOut,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => SuggestionDetailsPage(
//                   suggestion: widget.suggestion,
//                 ),
//               ),
//             );
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(14.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: widget.suggestion.imageUrl != null && widget.suggestion.imageUrl!.isNotEmpty
//                       ? Image.network(
//                     widget.suggestion.imageUrl!,
//                     width: 100,
//                     height: 120,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         child: Container(
//                           width: 100,
//                           height: 120,
//                           color: Colors.white,
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       width: 100,
//                       height: 120,
//                       color: Colors.grey[200],
//                       child: Icon(Icons.broken_image, size: 40, color: Colors.grey[400]),
//                     ),
//                   )
//                       : Container(
//                     width: 100,
//                     height: 120,
//                     color: Colors.grey[200],
//                     child: Icon(Icons.person, size: 40, color: Colors.grey[400]),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               widget.suggestion.user.createdBy,
//                               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           if (widget.showIconButton)
//                             PopupMenuButton<String>(
//                               onSelected: (value) {
//                                 if (value == 'delete') {
//                                   _showDeleteConfirmationDialog();
//                                 }
//                               },
//                               itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                                 const PopupMenuItem<String>(
//                                   value: 'delete',
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.delete_outline, color: Colors.red),
//                                       SizedBox(width: 8),
//                                       Text('حذف', style: TextStyle(color: Colors.red)),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                               icon: const Icon(Icons.more_vert),
//                             ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         widget.suggestion.description,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.bodySmall,
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     GlowingGPSIcon(),
//                                     const SizedBox(width: 6),
//                                     Expanded(
//                                       child: Text(
//                                         widget.suggestion.location.name ?? 'غير محدد',
//                                         style: Theme.of(context).textTheme.labelMedium,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Row(
//                                   children: [
//                                     Icon(Icons.calendar_month_outlined, size: 16, color: Colors.grey),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       widget.suggestion.createdat ?? 'غير محدد',
//                                       style: Theme.of(context).textTheme.labelMedium,
//                                     ),
//                                     Spacer(),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Text('(${widget.suggestion.likes})',
//                                                 style: const TextStyle(color: Colors.green)),
//                                             const SizedBox(width: 4),
//                                             const Icon(Icons.keyboard_arrow_up_outlined, color: Colors.green),
//                                           ],
//                                         ),
//                                         SizedBox(width: 10,),
//                                         Row(
//                                           children: [
//                                             const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.red),
//                                             const SizedBox(width: 4),
//                                             Text('(${widget.suggestion.dislikes})',
//                                                 style: const TextStyle(color: Colors.red)),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
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

class _SuggestionCardState extends State<SuggestionCard> {
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا المقترح؟'),
        actions: [
          TextButton(child: const Text('إلغاء'), onPressed: () => Navigator.pop(context)),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suggestion = widget.suggestion;
    return InkWell(
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
      // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header (Avatar + Name + Menu)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.user.createdBy,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    // SizedBox(height: 12,),
                    Row(
                      children: [
                        // const Icon(Icons.gps_fixed, size: 18, color: Colors.red),
                        GlowingGPSIcon(size: 18),
                         SizedBox(width: 6),
                        Text(
                          suggestion.location.name ?? 'غير محدد',
                          style: Theme.of(context).textTheme.labelMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                if (widget.showIconButton)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') _showDeleteConfirmationDialog();
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text('حذف', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 12),

            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: suggestion.imageUrl != null && suggestion.imageUrl!.isNotEmpty
                  ? Image.network(
                suggestion.imageUrl!,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(height: 160, color: Colors.white),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: Colors.grey[200],
                  child: Icon(Icons.broken_image, size: 60, color: Colors.grey[400]),
                ),
              )
                  : Container(
                height: 160,
                color: Colors.grey[100],
                child: const Center(child: Icon(Icons.image_not_supported, size: 60)),
              ),
            ),

            const SizedBox(height: 12),

            /// Description
            Text(
              suggestion.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            /// Meta Info (Location & Date)
            Row(
              children: [
                // const Icon(Icons.place_outlined, size: 18, color: Colors.grey),
                // const SizedBox(width: 6),
                // Expanded(
                //   child: Text(
                //     suggestion.location.name ?? 'غير محدد',
                //     style: Theme.of(context).textTheme.labelMedium,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),
                const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.MidGreen),
                SizedBox(width: 6),
                Text(
                  suggestion.createdat ?? 'غير محدد',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Likes / Dislikes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Icon(Icons.thumb_up_outlined, color: Colors.green, size: 20),
                    const SizedBox(width: 4),
                    Text('(${suggestion.likes})', style: const TextStyle(color: Colors.green)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.thumb_down_outlined, color: Colors.red, size: 20),
                    const SizedBox(width: 4),
                    Text('(${suggestion.dislikes})', style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


