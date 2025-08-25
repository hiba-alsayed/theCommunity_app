// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../domain/entities/Suggestions.dart';
// import '../bloc/suggestion_bloc.dart';
//
// class VotingSlider extends StatefulWidget {
//   final Suggestions suggestion;
//
//   const VotingSlider({super.key, required this.suggestion});
//
//   @override
//   State<VotingSlider> createState() => _VotingSliderState();
// }
//
// class _VotingSliderState extends State<VotingSlider> {
//   double _dragValue = 0.0;
//   bool _hasVoted = false;
//   int? _userVote;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadVoteStatus();
//   }
//
//   Future<void> _loadVoteStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final vote = prefs.getInt('suggestion_vote_${widget.suggestion.id}');
//     if (vote != null) {
//       setState(() {
//         _hasVoted = true;
//         _userVote = vote;
//       });
//     }
//   }
//   Future<void> _saveVoteStatus(int vote) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('suggestion_vote_${widget.suggestion.id}', vote);
//   }
//   void _handleVote(int value) {
//     // if (_hasVoted) return;
//
//     BlocProvider.of<SuggestionBloc>(context).add(
//       voteOnSuggestionEvent(
//         suggestionId: widget.suggestion.id,
//         value: value,
//         suggestion: widget.suggestion,
//       ),
//     );
//
//     _saveVoteStatus(value);
//     setState(() {
//       _hasVoted = true;
//       _userVote = value;
//       // _dragValue = 0.0;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SuggestionBloc, SuggestionState>(
//       builder: (context, state) {
//         final currentSuggestion = (state is VoteOnSuggestionSuccess)
//             ? state.updatedSuggestion
//             : widget.suggestion;
//
//         Icon swipeIcon;
//         if (_dragValue > 0) {
//           swipeIcon = const Icon(Icons.thumb_up, color: Colors.green);
//         } else if (_dragValue < 0) {
//           swipeIcon = const Icon(Icons.thumb_down, color: Colors.red);
//         } else {
//           swipeIcon = const Icon(Icons.swipe, color: Colors.grey);
//         }
//
//         return Column(
//           children: [
//             GestureDetector(
//               onHorizontalDragUpdate: (details) {
//                 if (!_hasVoted) {
//                   setState(() {
//                     _dragValue += details.delta.dx;
//                     _dragValue = _dragValue.clamp(-150, 150);
//                   });
//                 }
//               },
//               onHorizontalDragEnd: (details) {
//                 if (_hasVoted) return;
//
//                 if (_dragValue > 100) {
//                   _handleVote(1); // Like
//                 } else if (_dragValue < -100) {
//                   _handleVote(-1); // Dislike
//                 }
//
//                 setState(() {
//                   _dragValue = 0.0;
//                 });
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeOut,
//                 margin: const EdgeInsets.symmetric(horizontal: 8),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     )
//                   ],
//                 ),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Text('(${currentSuggestion.likes})',
//                                 style: const TextStyle(color: Colors.green)),
//                             const SizedBox(width: 4),
//                             const Icon(Icons.thumb_up, color: Colors.green),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Icon(Icons.thumb_down, color: Colors.red),
//                             const SizedBox(width: 4),
//                             Text('(${currentSuggestion.dislikes})',
//                                 style: const TextStyle(color: Colors.red)),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Transform.translate(
//                       offset: Offset(_dragValue, 0),
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             )
//                           ],
//                         ),
//                         child: swipeIcon,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               _hasVoted
//                   ? (_userVote == 1
//                   ? '👍 لقد صوت بالإعجاب!'
//                   : _userVote == -1
//                   ? '👎 لقد صوت بعدم الإعجاب!'
//                   : '')
//                   : 'اسحب للتصويت: يمين 👍 - يسار 👎',
//               style: const TextStyle(fontSize: 14, color: Colors.black87),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/app_color.dart';
import '../../../../core/widgets/snack_bar.dart';
import '../../domain/entities/Suggestions.dart';
import '../bloc/suggestion_bloc.dart';

class VotingSlider extends StatefulWidget {
  final Suggestions suggestion;

  const VotingSlider({super.key, required this.suggestion});

  @override
  State<VotingSlider> createState() => _VotingSliderState();
}

class _VotingSliderState extends State<VotingSlider> {
  double _dragValue = 0.0;
  bool _hasVoted = false;
  int? _userVote;

  @override
  void initState() {
    super.initState();
    _loadVoteStatus();
  }

  // Future<void> _loadVoteStatus() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final vote = prefs.getInt('suggestion_vote_${widget.suggestion.id}');
  //   if (vote != null) {
  //     setState(() {
  //       _hasVoted = true;
  //       _userVote = vote;
  //     });
  //   }
  // }
  //
  // Future<void> _saveVoteStatus(int vote) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('suggestion_vote_${widget.suggestion.id}', vote);
  // }
  Future<void> _loadVoteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = "CURRENT_USER_ID";
    final vote = prefs.getInt('suggestion_vote_${userId}_${widget.suggestion.id}');
    if (vote != null) {
      setState(() {
        _hasVoted = true;
        _userVote = vote;
      });
    } else {
      setState(() {
        _hasVoted = false;
        _userVote = null;
      });
    }
  }

  Future<void> _saveVoteStatus(int vote) async {
    final prefs = await SharedPreferences.getInstance();

    final userId = "CURRENT_USER_ID";

    await prefs.setInt('suggestion_vote_${userId}_${widget.suggestion.id}', vote);
  }
  void _tryVote(int value) {
    if (_hasVoted) {
      ScaffoldMessenger.of(context).showSnackBar(
        buildGlassySnackBar(
          message: 'لقد قمت بالتصويت بالفعل',
          color: AppColors.RichBerry,
          context: context,
        ),
      );
      return;
    }
    _handleVote(value);
  }

  void _handleVote(int value) {
    BlocProvider.of<SuggestionBloc>(context).add(
      voteOnSuggestionEvent(
        suggestionId: widget.suggestion.id,
        value: value,
        suggestion: widget.suggestion,
      ),
    );

    _saveVoteStatus(value);
    setState(() {
      _hasVoted = true;
      _userVote = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuggestionBloc, SuggestionState>(
      builder: (context, state) {
        final currentSuggestion = (state is VoteOnSuggestionSuccess)
            ? state.updatedSuggestion
            : widget.suggestion;

        Icon swipeIcon;
        if (_dragValue > 0) {
          swipeIcon = const Icon(Icons.thumb_up, color: Colors.green);
        } else if (_dragValue < 0) {
          swipeIcon = const Icon(Icons.thumb_down, color: Colors.red);
        } else {
          swipeIcon = const Icon(Icons.swipe, color: Colors.grey);
        }

        return Column(
          children: [
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragValue += details.delta.dx;
                  _dragValue = _dragValue.clamp(-150, 150);
                });
              },
              onHorizontalDragEnd: (details) {
                if (_dragValue > 100) {
                  _tryVote(1); // Like
                } else if (_dragValue < -100) {
                  _tryVote(-1); // Dislike
                }

                setState(() {
                  _dragValue = 0.0;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('(${currentSuggestion.likes})',
                                style: const TextStyle(color: Colors.green)),
                            const SizedBox(width: 4),
                            const Icon(Icons.thumb_up, color: Colors.green),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.thumb_down, color: Colors.red),
                            const SizedBox(width: 4),
                            Text('(${currentSuggestion.dislikes})',
                                style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ],
                    ),
                    Transform.translate(
                      offset: Offset(_dragValue, 0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: swipeIcon,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

