import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:graduation_project/features/campaigns/domain/entities/campaigns.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/strings/failures.dart';
import '../../../../core/widgets/glowing_gps.dart';
import '../../../Donation/presentation/bloc/donation_bloc.dart';
import '../../../../core pages/location_map_view_page.dart';
import '../../../profile/presentation/pages/get_profile_by_userid_page.dart';
import '../../data/models/campaigns_model.dart';
import '../../domain/entities/rating.dart';
import '../bloc/campaign_bloc.dart';

class CampaignDetailsPage extends StatefulWidget {
  final Campaigns campaign;

  const CampaignDetailsPage({Key? key, required this.campaign})
    : super(key: key);

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage> {
  final TextEditingController _amountController = TextEditingController();
  bool _alreadyRated = false;
  int _userRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool joined = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _joinCampaign() {
    if (!joined) {
      context.read<CampaignBloc>().add(JoinCampaignEvent(widget.campaign.id));}}

  // ===== NEW HELPER METHOD TO LAUNCH THE URL =====
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }

  void _donateToCampaign() {
    // Use a TextEditingController and a FormKey for the dialog
    final TextEditingController amountController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('تبرع للحملة'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'المبلغ'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'الرجاء إدخال مبلغ';
                if (double.tryParse(value) == null || double.parse(value) <= 0) {
                  return 'الرجاء إدخال مبلغ صحيح';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final amount = double.parse(amountController.text);

                  // --- PRINT STATEMENT #1: VERIFY UI DATA ---
                  print("✅ UI LAYER: Triggering event with projectId: ${widget.campaign.id}, amount: $amount");
                  // ---------------------------------------------

                  // Send the event to the BLoC
                  context.read<DonationBloc>().add(
                    MakeDonationEvent(projectId: widget.campaign.id, amount: amount),
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('تبرع الآن'),
            ),
          ],
        );
      },
    );
  }


  void _showMessageDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('نجاح'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
  void _openMap(BuildContext context) {
    if (widget.campaign.campaignLocation.latitude == null ||
        widget.campaign.campaignLocation.longitude == null) {
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
              latitude: widget.campaign.campaignLocation.latitude!,
              longitude: widget.campaign.campaignLocation.longitude!,
              locationName:
                  widget.campaign.campaignLocation.name ?? 'موقع المقترح',
            ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   final campaign = widget.campaign;
  //
  //   return BlocListener<CampaignBloc, CampaignState>(
  // listener: (context, state) {
  //   if (state is CampaignJoinedSuccessfully) {
  //     setState(() {
  //       joined = true;
  //     });
  //     _showMessageDialog(state.message);
  //   }
  //   else if (state is AlreadyJoinedState) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(state.message)));
  //   }
  //   else if (state is RatingCampaignSuccess) {
  //     print("✅ RatingCampaignSuccess: ${state.message}");
  //     _showMessageDialog(state.message);
  //     setState(() {
  //       _userRating = 0;
  //       _commentController.clear();
  //     });
  //   }
  //   else if (state is RatingCampaignError) {
  //     print("❌ RatingCampaignError: ${state.message}");
  //     if (state.message == "لقد قمت بتقييم هذا المشروع مسبقًا.") {
  //       showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //           title: const Text("تنبيه"),
  //           content: Text(state.message),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(),
  //               child: const Text("حسناً"),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   }
  //   else if (state is CampaignErrorState) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(state.message)));
  //   }
  // },
  // child: Scaffold(
  //     appBar: AppBar(title: Text(campaign.title)),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: ListView(
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(12),
  //             child:
  //                 campaign.imageUrl != null
  //                     ? Image.network(
  //                       campaign.imageUrl!,
  //                       height: 200,
  //                       width: double.infinity,
  //                       fit: BoxFit.cover,
  //                     )
  //                     : Container(
  //                       height: 200,
  //                       color: Colors.grey[300],
  //                       child: const Icon(Icons.image, size: 60),
  //                     ),
  //           ),
  //           const SizedBox(height: 16),
  //
  //           Text("الوصف:", style: Theme.of(context).textTheme.titleMedium),
  //           Text(campaign.description),
  //           const SizedBox(height: 16),
  //
  //           Text("الحالة: ${campaign.status}"),
  //           const SizedBox(height: 16),
  //           Row(
  //             children: [
  //               CircleAvatar(
  //                 backgroundImage: NetworkImage(
  //                   campaign.campaignUser.userimage,
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               Text("بواسطة: ${campaign.campaignUser.createdBy}"),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           Text(campaign.createdAt),
  //           const SizedBox(height: 16),
  //
  //           if (campaign.status == "نشطة") ...[
  //             // Text("عدد المشاركين الحالي: ${campaign.joinedParticipants}"),
  //             Text("عدد المشاركين المطلوب: ${campaign.numberOfParticipants}"),
  //             Text("المبلغ المطلوب: ${campaign.requiredAmount}"),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 16),
  //               child: Card(
  //                 elevation: 2,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: InkWell(
  //                   borderRadius: BorderRadius.circular(12),
  //                   onTap: () => _openMap(context),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(16),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text(
  //                           'الموقع',
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 16,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 10),
  //                         Row(
  //                           children: [
  //                             GlowingGPSIcon(),
  //                             const SizedBox(width: 4),
  //                             if (widget.campaign.campaignLocation.name != null)
  //                               Text(widget.campaign.campaignLocation.name!),
  //                             const SizedBox(width: 8),
  //                             Text(
  //                               '(اضغط لعرض الموقع على الخريطة)',
  //                               style: TextStyle(
  //                                 color: Colors.grey[600],
  //                                 // decoration: TextDecoration.underline,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 8),
  //                         if (widget.campaign.campaignLocation.latitude !=
  //                             null &&
  //                             widget.campaign.campaignLocation.longitude !=
  //                                 null)
  //                           LocationPreview(
  //                             latitude:
  //                             widget.campaign.campaignLocation.latitude!,
  //                             longitude:
  //                             widget.campaign.campaignLocation.longitude!,
  //                           ),
  //                         const SizedBox(height: 8),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //
  //             ElevatedButton(
  //               onPressed: joined ? null : _joinCampaign,
  //               child: joined
  //                   ? const Text("تم الانضمام")
  //                   : const Text("انضم للحملة"),
  //             ),
  //             const SizedBox(height: 8), // Spacing between buttons
  //
  //             // ===== HERE IS THE NEW DONATION BUTTON =====
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.teal, // A distinct color for donation
  //                 foregroundColor: Colors.white,
  //               ),
  //               onPressed: _donateToCampaign,
  //               child: const Text("تبرع للحملة"),
  //             ),
  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;

    // Use MultiBlocListener to listen to both Blocs at the same time.
    return MultiBlocListener(
      listeners: [
        // 1. Your existing listener for CampaignBloc (no changes here)
        BlocListener<CampaignBloc, CampaignState>(
          listener: (context, state) {
            if (state is CampaignJoinedSuccessfully) {
              setState(() {
                joined = true;
              });
              _showMessageDialog(state.message);
            } else if (state is AlreadyJoinedState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is RatingCampaignSuccess) {
              print("✅ RatingCampaignSuccess: ${state.message}");
              _showMessageDialog(state.message);
              setState(() {
                _userRating = 0;
                _commentController.clear();
              });
            } else if (state is RatingCampaignError) {
              print("❌ RatingCampaignError: ${state.message}");
              if (state.message == "لقد قمت بتقييم هذا المشروع مسبقًا.") {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("تنبيه"),
                    content: Text(state.message),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("حسناً"),
                      ),
                    ],
                  ),
                );
              }
            } else if (state is CampaignErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),

        // ===== 2. ADD THE NEW LISTENER FOR DONATIONBLOC HERE =====
        BlocListener<DonationBloc, DonationState>(
          listener: (context, state) {
            if (state is DonationLoading) {
              // Optional: Show a loading indicator while processing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري معالجة طلب التبرع...')),
              );
            }
            else if (state is DonationSuccess) {
              _launchURL(state.donationEntity.url);
            }
            else if (state is DonationFailure) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('فشل التبرع'),
                  content: Text(state.errorMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('حسناً'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(campaign.title)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            // --- The rest of your UI remains exactly the same ---
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: campaign.imageUrl != null
                    ? Image.network(
                  campaign.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 60),
                ),
              ),
              const SizedBox(height: 16),
              Text("الوصف:", style: Theme.of(context).textTheme.titleMedium),
              Text(campaign.description),
              const SizedBox(height: 16),
              Text("الحالة: ${campaign.status}"),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GetProfileByUserIdPage(
                        userId: campaign.campaignUser.userid,
                        userName: campaign.campaignUser.createdBy,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        campaign.campaignUser.userimage,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text("بواسطة: ${campaign.campaignUser.createdBy}"),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(campaign.createdAt),
              const SizedBox(height: 16),
              if (campaign.status == "نشطة") ...[
                // Your widgets for "active" campaigns...
                ElevatedButton(
                  onPressed: joined ? null : _joinCampaign,
                  child: joined
                      ? const Text("تم الانضمام")
                      : const Text("انضم للحملة"),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _donateToCampaign,
                  child: const Text("تبرع للحملة"),
                ),
            ] else if (campaign.status == "منجزة") ...[
              Text("عدد المشاركين النهائي: ${campaign.joinedParticipants}"),
              Text(
                "المبلغ الذي تم جمعه: ${campaign.donationTotal ?? 'غير متوفر'}",
              ),
              Text("متوسط التقييم: ${widget.campaign.avgRating?.toStringAsFixed(1) ?? 'غير متوفر'}"),
              const SizedBox(height: 20),
              Text("قيم الحملة", style: Theme.of(context).textTheme.titleMedium),
              RatingBar.builder(
                initialRating: 0.0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _userRating = rating.toInt();
                  });
                },
              ),
              const SizedBox(height: 10),
              // Comment input:
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: "أضف تعليقاً (اختياري)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_userRating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('يرجى اختيار تقييم')),
                    );
                    return;
                  }
                  context.read<CampaignBloc>().add(RateCompletedCampaignEvent(
                    campaignId: campaign.id,
                    rating: _userRating,
                    comment: _commentController.text,
                  ));
                },
                child: const Text("إرسال التقييم"),
              ),
              const SizedBox(height: 10),
              if (widget.campaign.ratings != null && widget.campaign.ratings!.isNotEmpty)
                ...widget.campaign.ratings!.map((rating) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            rating.user,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            rating.date,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          rating.rating,
                              (index) => const Icon(Icons.star, color: Colors.amber, size: 18),
                        ),
                      ),
                      if (rating.comment.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          rating.comment,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                )),
            ],
          ],

        ),
      ),
  ),
    );
  }
}

