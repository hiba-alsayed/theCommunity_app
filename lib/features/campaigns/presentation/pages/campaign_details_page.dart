import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:graduation_project/core/app_color.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import 'package:graduation_project/features/campaigns/domain/entities/campaigns.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/glowing_gps.dart';
import '../../../../core/widgets/snack_bar.dart';
import '../../../Donation/presentation/bloc/donation_bloc.dart';
import '../../../../core pages/location_map_view_page.dart';
import '../../../profile/presentation/pages/get_profile_by_userid_page.dart';
import '../bloc/campaign_bloc.dart';
import '../widgets/campaign_summary_stats.dart';
import 'all_rating_page.dart';

class CampaignDetailsPage extends StatefulWidget {
  final Campaigns campaign;

  const CampaignDetailsPage({Key? key, required this.campaign})
    : super(key: key);

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  int _userRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool joined = false;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  final Map<String, Map<String, dynamic>> categoryIcons = {
    'تنظيف وتزيين الأماكن العامة': {
      'icon': Icons.cleaning_services,
      'color': Colors.lightBlue,
    },
    'حملات تشجير': {'icon': Icons.nature, 'color': Colors.green},
    'يوم خيري': {'icon': Icons.volunteer_activism, 'color': Colors.pink},
    'ترميم أضرار (كوارث , عدوان)': {
      'icon': Icons.home_repair_service,
      'color': Colors.brown,
    },
    'إنارة الشوارع بالطاقة الشمسية': {
      'icon': Icons.lightbulb,
      'color': Colors.amber,
    },
    // 'طوارئ': {'icon': Icons.crisis_alert, 'color': Colors.red},
    // 'صحة': {'icon': Icons.health_and_safety, 'color': Colors.purple},
    // 'تعليم': {'icon': Icons.school, 'color': Colors.deepOrange},
  };
  void _showAnimatedDonationDialog({
    required BuildContext buildContext,
    required GlobalKey<FormState> formKey,
    required TextEditingController amountController,
    required int campaignId,
  }) {
    showGeneralDialog(
      context: buildContext,
      barrierDismissible: true,
      barrierLabel: 'Close',
      transitionDuration: 400.ms,
      transitionBuilder: (context, anim1, anim2, child) {
        return Animate(
          effects: [
            FadeEffect(duration: 400.ms, curve: Curves.easeOut),
            ScaleEffect(duration: 400.ms, curve: Curves.easeOut),
          ],
          child: child,
        );
      },
      pageBuilder: (dialogContext, anim1, anim2) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(dialogContext).canvasColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.OceanBlue.withOpacity(0.1),
                  child: Icon(Icons.credit_card_rounded, size: 30, color: AppColors.OceanBlue),
                ).animate().fadeIn(delay: 200.ms).shake(hz: 3, duration: 800.ms),
                const SizedBox(height: 16),
                Text(
                  'تبرع للحملة',
                  style: Theme.of(dialogContext).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.5, duration: 600.ms),

                const SizedBox(height: 24),
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'المبلغ',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                      ),
                      prefixIcon: Icon(Icons.attach_money_sharp, color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'الرجاء إدخال مبلغ';
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return 'الرجاء إدخال مبلغ صحيح';
                      }
                      return null;
                    },
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5, duration: 600.ms),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('إلغاء',style: TextStyle(color: Colors.grey),),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [AppColors.OceanBlue, Colors.blue.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.OceanBlue.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            final amount = double.parse(amountController.text);
                            buildContext.read<DonationBloc>().add(
                              MakeDonationEvent(
                                projectId: campaignId,
                                amount: amount,
                              ),
                            );
                            Navigator.pop(dialogContext);
                          }
                        },
                        // icon: const Icon(Icons.payment, size: 18),
                        label: const Text('تبرع الآن'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, duration: 600.ms),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    double requiredAmountValue =
        double.tryParse(widget.campaign.requiredAmount) ?? 0.0;
    double targetProgress =
        requiredAmountValue > 0
            ? widget.campaign.donationTotal / requiredAmountValue
            : 0.0;
    if (targetProgress > 1.0) targetProgress = 1.0;

    _progressAnimation = Tween<double>(begin: 0.0, end: targetProgress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _commentController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _joinCampaign() {
    if (!joined) {
      context.read<CampaignBloc>().add(JoinCampaignEvent(widget.campaign.id));
    }
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
    }
  }
  void _donateToCampaign() {
    final TextEditingController amountController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    _showAnimatedDonationDialog(
      buildContext: context,
      formKey: formKey,
      amountController: amountController,
      campaignId: widget.campaign.id,
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

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;

    double requiredAmountValue =
        double.tryParse(campaign.requiredAmount) ?? 0.0;
    double progress =
        requiredAmountValue > 0
            ? campaign.donationTotal / requiredAmountValue
            : 0.0;
    if (progress > 1.0) progress = 1.0;
    final categoryData =
        categoryIcons[campaign.category] ??
        {'icon': Icons.category, 'color': Colors.grey};

    return MultiBlocListener(
      listeners: [
        BlocListener<CampaignBloc, CampaignState>(
          listenWhen: (previous, current) {
            return previous != current;
          },
          listener: (context, state) {
            if (state is CampaignJoinedSuccessfully) {
              setState(() {
                joined = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                buildGlassySnackBar(
                  message: 'تم الانضمام بنجاح! شكرا لمشاركتك',
                  color: AppColors.CedarOlive,
                  context: context,
                ),
              );
            } else if (state is AlreadyJoinedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildGlassySnackBar(
                  message: 'لقد قمت بالانضمام مسبقًا!',
                  color: AppColors.RichBerry,
                  context: context,
                ),
              );
            } else if (state is RatingCampaignSuccess) {
              // print("✅ RatingCampaignSuccess: ${state.message}");
              ScaffoldMessenger.of(context).showSnackBar(
                buildGlassySnackBar(
                  message: 'تم التقييم بنجاح',
                  color: AppColors.CedarOlive,
                  context: context,
                ),
              );
              setState(() {
                _userRating = 0;
                _commentController.clear();
              });
            } else if (state is RatingCampaignError) {
              // print("❌ RatingCampaignError: ${state.message}");
              if (state.message == "لقد قمت بتقييم هذا المشروع مسبقًا.") {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildGlassySnackBar(
                    message: 'لقد قمت بتقييم هذا المشروع مسبقًا!',
                    color: AppColors.RichBerry,
                    context: context,
                  ),
                );
              }
            } else if (state is CampaignErrorState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
        BlocListener<DonationBloc, DonationState>(
          listener: (context, state) {
            if (state is DonationLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildGlassySnackBar(
                  message: 'جاري معالجة طلب التبرع ...',
                  color: AppColors.RichBerry,
                  context: context,
                ),
              );
            } else if (state is DonationSuccess) {
              _launchURL(state.donationEntity.url);
            } else if (state is DonationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildGlassySnackBar(
                  message: 'فشل التبرع',
                  color: AppColors.RichBerry,
                  context: context,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (campaign.imageUrl != null && campaign.imageUrl!.isNotEmpty)
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
                          campaign.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, _) =>
                                  const Center(child: Text("فشل تحميل الصورة")),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: LoadingWidget(),
                            );
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
                    child: const Center(child: Text('لا توجد صورة')),
                  ),
                // Title + category
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          campaign.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
                          color: categoryData['color'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: categoryData['color'],
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              categoryData['icon'],
                              size: 16,
                              color: categoryData['color'],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              campaign.category,
                              style: TextStyle(
                                fontSize: 12,
                                color: categoryData['color'],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (campaign.status == "نشطة") ...[
                  // Donation Progress Bar and Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Animate(
                          effects: [
                            CustomEffect(
                              duration: 1500.ms,
                              curve: Curves.easeOutCirc,
                              builder: (context, value, child) {
                                final animatedTotal = value * campaign.donationTotal;
                                return Text(
                                  "${animatedTotal.toStringAsFixed(2)} تم جمعها , ${campaign.requiredAmount} مطلوب ",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                );
                              },
                            ),
                          ],
                          child: Text(
                            "0.00 تم جمعها , ${campaign.requiredAmount} مطلوب ",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // PROGRESS BAR ---
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: _progressAnimation.value,
                              backgroundColor: Colors.grey[300],
                              color: Colors.green,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(5),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                // User info + date
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => GetProfileByUserIdPage(
                                    userId: campaign.campaignUser.userid,
                                    userName: campaign.campaignUser.createdBy,
                                  ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "بواسطة: ${campaign.campaignUser.createdBy}",
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
                            campaign.createdAt,
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
                    campaign.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Location Card
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
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                GlowingGPSIcon(),
                                const SizedBox(width: 4),
                                if (widget.campaign.campaignLocation.name !=
                                    null)
                                  Expanded(
                                    child: Text(
                                      widget.campaign.campaignLocation.name!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  '(اضغط لعرض الموقع على الخريطة)',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (widget.campaign.campaignLocation.latitude !=
                                    null &&
                                widget.campaign.campaignLocation.longitude !=
                                    null)
                              LocationPreview(
                                latitude:
                                    widget.campaign.campaignLocation.latitude!,
                                longitude:
                                    widget.campaign.campaignLocation.longitude!,
                              ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Conditional UI based on campaign status
                if (campaign.status == "نشطة") ...[
                  CampaignSummaryStats(campaign: campaign),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                          ElevatedButton(
                            onPressed: _joinCampaign,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.OceanBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              minimumSize: const Size(double.infinity, 0),
                            ),
                            child: const Text(
                              "انضم للحملة",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(color: Colors.white),
                          child: GestureDetector(
                            onTap: _donateToCampaign,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "تبرع للحملة",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.OceanBlue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  //الحملة المنجزة
                ] else if (campaign.status == "منجزة") ...[
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 45,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: TabBar(
                            dividerColor: Colors.transparent,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              color: AppColors.OceanBlue,
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.OceanBlue.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black87,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            tabs: const [
                              Tab(text: 'التفاصيل النهائية'),
                              Tab(text: 'التقييمات'),
                            ],
                          ),
                        ),

                        // --- TAB BAR VIEW ---
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 400,
                              maxHeight: MediaQuery.of(context).size.height,
                            ),
                            child: TabBarView(
                              children: [
                                // --- TAB 1 ---
                                CampaignSummaryStats (campaign: campaign),
                                // --- TAB 2---
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "شاركنا رأيك في الحملة",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(height: 16),
                                              Center(
                                                child: RatingBar.builder(
                                                  initialRating:
                                                      _userRating.toDouble(),
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: false,
                                                  itemCount: 5,
                                                  itemPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4.0,
                                                      ),
                                                  itemBuilder:
                                                      (context, _) =>
                                                          const Icon(
                                                            Icons.star_rounded,
                                                            color: Colors.amber,
                                                          ),
                                                  onRatingUpdate: (rating) {
                                                    setState(() {
                                                      _userRating =
                                                          rating.toInt();
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              TextField(
                                                controller: _commentController,
                                                decoration: const InputDecoration(
                                                  hintText:
                                                      "أضف تعليقاً (اختياري)",
                                                  border: OutlineInputBorder(),
                                                  filled: true,
                                                  fillColor: Color.fromARGB(
                                                    255,
                                                    245,
                                                    245,
                                                    245,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Colors
                                                                  .transparent,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                8,
                                                              ),
                                                            ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              AppColors
                                                                  .OceanBlue,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                8,
                                                              ),
                                                            ),
                                                      ),
                                                ),
                                                maxLines: 3,
                                              ),
                                              const SizedBox(height: 16),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (_userRating == 0) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'يرجى اختيار تقييم أولاً',
                                                        ),
                                                      ),
                                                    );
                                                    return;
                                                  }
                                                  context.read<CampaignBloc>().add(
                                                    RateCompletedCampaignEvent(
                                                      campaignId: campaign.id,
                                                      rating: _userRating,
                                                      comment:
                                                          _commentController
                                                              .text,
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.OceanBlue,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                      ),
                                                  minimumSize: const Size(
                                                    double.infinity,
                                                    0,
                                                  ),
                                                ),
                                                child: const Text(
                                                  "إرسال التقييم",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      if (widget.campaign.ratings != null &&
                                          widget.campaign.ratings!.isNotEmpty)
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "التقييمات السابقة (${widget.campaign.ratings!.length})",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                if (widget
                                                        .campaign
                                                        .ratings!
                                                        .length >
                                                    3)
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (
                                                                context,
                                                              ) => AllRatingsPage(
                                                                ratings:
                                                                    widget
                                                                        .campaign
                                                                        .ratings!,
                                                                campaignTitle:
                                                                    widget
                                                                        .campaign
                                                                        .title,
                                                                campaign:
                                                                    widget
                                                                        .campaign,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                      "عرض الكل",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.OceanBlue,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: min(
                                                3,
                                                widget.campaign.ratings!.length,
                                              ),
                                              itemBuilder: (context, index) {
                                                final rating =
                                                    widget
                                                        .campaign
                                                        .ratings![index];
                                                return RatingCard(
                                                  rating: rating,
                                                );
                                              },
                                            ).animate().fadeIn(delay: 400.ms ,duration: 800.ms).slideX(begin: 0.5),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}