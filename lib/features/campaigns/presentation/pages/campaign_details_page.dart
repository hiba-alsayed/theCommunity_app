import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:graduation_project/core/app_color.dart';
import 'package:graduation_project/features/campaigns/domain/entities/campaigns.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/glowing_gps.dart';
import '../../../Donation/presentation/bloc/donation_bloc.dart';
import '../../../../core pages/location_map_view_page.dart';
import '../../../profile/presentation/pages/get_profile_by_userid_page.dart';
import '../bloc/campaign_bloc.dart';
class CampaignDetailsPage extends StatefulWidget {
  final Campaigns campaign;

  const CampaignDetailsPage({Key? key, required this.campaign})
      : super(key: key);

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}
class _CampaignDetailsPageState extends State<CampaignDetailsPage> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  bool _alreadyRated = false;
  int _userRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool joined = false;
  final _formKey = GlobalKey<FormState>();
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
    // Add more campaign categories as needed from your data
    'طوارئ': {'icon': Icons.crisis_alert, 'color': Colors.red},
    'صحة': {'icon': Icons.health_and_safety, 'color': Colors.purple},
    'تعليم': {'icon': Icons.school, 'color': Colors.deepOrange},
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync:this,
      duration: const Duration(milliseconds: 3000),
    );
    double requiredAmountValue = double.tryParse(widget.campaign.requiredAmount) ?? 0.0;
    double targetProgress = requiredAmountValue > 0 ? widget.campaign.donationTotal / requiredAmountValue : 0.0;
    if (targetProgress > 1.0) targetProgress = 1.0;

    // Define the animation tween
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: targetProgress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Start the animation
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }
  void _donateToCampaign() {
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
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
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
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final amount = double.parse(amountController.text);
                  print(
                      "✅ UI LAYER: Triggering event with projectId: ${widget.campaign.id}, amount: $amount");
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
        builder: (context) => LocationMapPage(
          latitude: widget.campaign.campaignLocation.latitude!,
          longitude: widget.campaign.campaignLocation.longitude!,
          locationName: widget.campaign.campaignLocation.name ?? 'موقع المقترح',
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: const Color(0xFF0172B2)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;

    double requiredAmountValue = double.tryParse(campaign.requiredAmount) ?? 0.0;
    double progress = requiredAmountValue > 0 ? campaign.donationTotal / requiredAmountValue : 0.0;
    if (progress > 1.0) progress = 1.0;
    final categoryData = categoryIcons[campaign.category] ??
        {'icon': Icons.category, 'color': Colors.grey};

    return MultiBlocListener(
      listeners: [
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
        BlocListener<DonationBloc, DonationState>(
          listener: (context, state) {
            if (state is DonationLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري معالجة طلب التبرع...')),
              );
            } else if (state is DonationSuccess) {
              _launchURL(state.donationEntity.url);
            } else if (state is DonationFailure) {
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
                          errorBuilder: (context, error, _) =>
                          const Center(child: Text("فشل تحميل الصورة")),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
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
                          color: categoryData['color'].withOpacity(
                            0.2,
                          ),
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
                if (campaign.status== "نشطة")...[
                  // Donation Progress Bar and Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${campaign.donationTotal.toStringAsFixed(2)} تم جمعها , ${campaign.requiredAmount} مطلوب ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                  const SizedBox(height: 20)],
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
                              builder: (context) => GetProfileByUserIdPage(
                                userId: campaign.campaignUser.userid,
                                userName: campaign.campaignUser.createdBy,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.person,
                                size: 14, color: Colors.grey),
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
                          const Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            campaign.createdAt,
                            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
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
                        color: Colors.grey[800]),
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
                                if (widget.campaign.campaignLocation.name != null)
                                  Expanded(
                                    child: Text(
                                      widget.campaign.campaignLocation.name!,
                                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
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
                            if (widget.campaign.campaignLocation.latitude != null &&
                                widget.campaign.campaignLocation.longitude != null)
                              LocationPreview(
                                latitude: widget.campaign.campaignLocation.latitude!,
                                longitude: widget.campaign.campaignLocation.longitude!,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          'المبلغ الذي تم جمعه',
                          "${campaign.donationTotal.toStringAsFixed(2)}",
                          Icons.attach_money,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          'المشاركون',
                          campaign.joinedParticipants.toString(),
                          Icons.people,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          'المبلغ المطلوب',
                          campaign.requiredAmount,
                          Icons.request_quote,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        if (!joined)
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
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                             color: Colors.white
                          ),
                          child: GestureDetector(
                            onTap: _donateToCampaign,
                            child:  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "تبرع للحملة",
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.OceanBlue),
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
                      children: [
                        TabBar(
                          indicatorColor: AppColors.OceanBlue,
                          labelColor: AppColors.OceanBlue,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          tabs: const [
                            Tab(text: 'التفاصيل'),
                            Tab(text: 'التقييمات'),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: TabBarView(
                            children: [
                              // Tab 1: Details for Completed Campaign
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildStatCard(
                                      'المبلغ الذي تم جمعه',
                                      "${campaign.donationTotal.toStringAsFixed(2)}",
                                      Icons.attach_money,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildStatCard(
                                      'عدد المشاركين النهائي',
                                      campaign.joinedParticipants.toString(),
                                      Icons.people,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildStatCard(
                                      'متوسط التقييم',
                                      widget.campaign.avgRating?.toStringAsFixed(1) ?? 'غير متوفر',
                                      Icons.star,
                                    ),
                                  ],
                                ),
                              ),
                              // Tab 2: Ratings for Completed Campaign
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("قيم الحملة",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    RatingBar.builder(
                                      initialRating: _userRating.toDouble(),
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
                                    TextField(
                                      controller: _commentController,
                                      decoration: const InputDecoration(
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
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.OceanBlue,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        minimumSize: const Size(double.infinity, 0),
                                      ),
                                      child: const Text("إرسال التقييم",style:TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    ),
                                    const SizedBox(height: 20),
                                    if (widget.campaign.ratings != null &&
                                        widget.campaign.ratings!.isNotEmpty)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("التقييمات السابقة", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 10),
                                          ...widget.campaign.ratings!.map((rating) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Card(
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(12.0),
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
                                                            (index) => const Icon(Icons.star,
                                                            color: Colors.amber, size: 18),
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
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
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