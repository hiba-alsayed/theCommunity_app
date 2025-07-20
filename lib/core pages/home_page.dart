import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/campaigns/presentation/pages/get_nearby_campaigns.dart';
import 'package:graduation_project/features/campaigns/presentation/pages/recommended_page.dart';
import 'package:graduation_project/features/complaints/presentation/pages/get_nearby_complaints_page.dart';
import 'package:graduation_project/features/suggestions/presentation/pages/nearby_suggestions_page.dart';
import '../core/app_color.dart';
import '../core/widgets/glowing_gps.dart';
import '../core/widgets/loading_widget.dart';
import '../features/campaigns/presentation/bloc/campaign_bloc.dart';
import '../features/campaigns/presentation/pages/promoted_campaigns_page.dart';
import '../features/campaigns/presentation/widgets/campaign_list_widget.dart';
import '../features/campaigns/presentation/widgets/promoted_carousel_widget.dart';
import '../features/campaigns/presentation/widgets/recommended_carousel_widget.dart';
import '../features/notifications/presentation/page/notification_page.dart';
import '../features/campaigns/domain/entities/campaigns.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedCategoryName;
  int? _selectedCategoryId;
  List<Campaigns>? _cachedAllCampaigns;
  List<Campaigns>? _filteredCampaigns;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  Future<void> _loadInitialData() async {
    context.read<CampaignBloc>().add(GetRecommendedCampaignsEvent());
    context.read<CampaignBloc>().add(GetPromotedCampaignsEvent());
    context.read<CampaignBloc>().add(GetAllCampaignsEvent());
    setState(() {
      _selectedCategoryName = null;
      _selectedCategoryId = null;
      _searchController.clear();
      _searchQuery = '';
    });
  }
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterCampaigns();
    });
  }
  void _filterCampaigns() {
    if (_cachedAllCampaigns == null || _searchQuery.isEmpty) {
      _filteredCampaigns = _cachedAllCampaigns;
      return;
    }

    _filteredCampaigns = _cachedAllCampaigns!
        .where((campaign) =>
    campaign.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        campaign.description.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _openFilterDialog() {
    context.read<CampaignBloc>().add(GetCategoriesEvent());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BlocBuilder<CampaignBloc, CampaignState>(
          builder: (context, state) {
            if (state is LoadingCategories) {
              return const SizedBox(
                height: 200,
                child: Center(child: LoadingWidget()),
              );
            } else if (state is CategoriesLoaded) {
              final categories = state.categories;
              final Map<String, Map<String, dynamic>> categoryIcons = {
                'تنظيف': {
                  'icon': Icons.cleaning_services,
                  'color': Colors.lightBlue,
                },
                'تشجير': {'icon': Icons.nature, 'color': Colors.green},
                'خيري': {
                  'icon': Icons.volunteer_activism,
                  'color': Colors.pink,
                },
                'ترميم': {
                  'icon': Icons.home_repair_service,
                  'color': Colors.brown,
                },
                'إنارة': {'icon': Icons.lightbulb, 'color': Colors.amber},
              };

              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'اختر تصنيف',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Option to show all campaigns
                    ListTile(
                      leading: const Icon(
                        Icons.all_inclusive,
                        color: Colors.blue,
                      ),
                      title: const Text('الكل'),
                      onTap: () {
                        setState(() {
                          _selectedCategoryName = null;
                          _selectedCategoryId = null;
                          _searchController.clear();
                          _searchQuery = '';
                        });
                        context.read<CampaignBloc>().add(
                          GetAllCampaignsEvent(),
                        ); // Fetch all campaigns
                        Navigator.pop(context);
                      },
                    ),
                    ...categories.map((category) {
                      final match = categoryIcons.entries.firstWhere(
                            (entry) => category.name.contains(entry.key),
                        orElse:
                            () => MapEntry('', {
                          'icon':
                          Icons.category,
                          'color': Colors.grey,
                        }),
                      );

                      return ListTile(
                        leading: Icon(
                          match.value['icon'],
                          color: match.value['color'],
                        ),
                        title: Text(category.name),
                        onTap: () {
                          setState(() {
                            _selectedCategoryName = category.name;
                            _selectedCategoryId = category.id;
                            _searchController.clear();
                            _searchQuery = '';
                          });
                          context.read<CampaignBloc>().add(
                            GetAllCampaignsByCategoryEvent(
                              category.id,
                            ),
                          );
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ],
                ),
              );
            } else if (state is CampaignErrorState) {
              return SizedBox(
                  height: 200,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'حدث خطأ: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ) );
              }
                  return const SizedBox.shrink();
            },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.OceanBlue, Colors.white],
              stops: [0.0, 0.2],
            ),
          ),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: _loadInitialData,
              color: AppColors.OceanBlue,
              backgroundColor: AppColors.WhisperWhite,
              child: CustomScrollView(
                slivers: [
                  // Top Bar: Notification, Search, GPS
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.WhisperWhite,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.OceanBlue.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.notifications_none,
                                color: Colors.black,
                                size: 20,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const NotificationPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: AppColors.WhisperWhite,
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.LightGrey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'البحث...',
                                  hintStyle: TextStyle(
                                    color: AppColors.CharcoalGrey.withOpacity(0.6),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search_outlined,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      _searchController.clear();
                                      _onSearchChanged();
                                    },
                                  )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 10.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide(
                                      color: AppColors.LightGrey,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: const BorderSide(
                                      color: AppColors.OceanBlue,
                                      width: 2.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: AppColors.LightGrey.withOpacity(0.5),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: AppColors.CharcoalGrey,
                                ),
                                cursorColor: AppColors.OceanBlue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          //menu
                          PopupMenuButton<String>(
                            offset: const Offset(0, 50),
                            itemBuilder:
                                (BuildContext context) => <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'campaigns',
                                child: Row(
                                  children: [
                                    Icon(Icons.campaign, color: AppColors.SunsetOrange),
                                    const SizedBox(width: 10),
                                    Text(
                                      "حملات",
                                      style: TextStyle(
                                        color: AppColors.SunsetOrange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'initiatives',
                                child: Row(
                                  children: [
                                    Icon(Icons.lightbulb, color: AppColors.OceanBlue),
                                    const SizedBox(width: 10),
                                    Text(
                                      "مبادرات",
                                      style: TextStyle(color: AppColors.OceanBlue),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'complaints',
                                child: Row(
                                  children: [
                                    Icon(Icons.report_problem, color: AppColors.RichBerry),
                                    const SizedBox(width: 10),
                                    Text(
                                      "شكاوى",
                                      style: TextStyle(color: AppColors.RichBerry),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (String value) {
                              if (value == 'campaigns') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => GetNearbyCampaignsPage()),
                                );
                              } else if (value == 'initiatives') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) =>NearbySuggestionsScreen()),
                                );
                              }
                              else if (value == 'complaints') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) =>GetNearbyComplaintsPage()),
                                );
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: AppColors.WhisperWhite,
                            elevation: 8,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.WhisperWhite,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.OceanBlue.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(child:Icon(Icons.gps_fixed, color: AppColors.OceanBlue,size: 22,),),
                            ), // Adjust shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Recommended Campaigns Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'حملات مقترحة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RecommendedPage(),
                                ),
                              );
                            },
                            child:  Text(
                              'عرض الكل',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BlocBuilder<CampaignBloc, CampaignState>(
                      buildWhen:
                          (previous, current) =>
                      current is LoadingRecommendedCampaigns ||
                          current is RecommendedCampaignsLoaded ||
                          current is CampaignErrorState,
                      builder: (context, state) {
                        if (state is LoadingRecommendedCampaigns) {
                          return const Center(
                            child: LoadingWidget(),
                          );
                        } else if (state is RecommendedCampaignsLoaded) {
                          final displayedCampaigns =
                          state.recommendedCampaigns.take(4).toList();
                          if (displayedCampaigns.isEmpty) {
                            return const Center(child: Text('لا يوجد مقترحات بعد'));
                          }
                          return RecommendedCarouselWidget(
                            campaigns: displayedCampaigns,
                          );
                        } else if (state is CampaignErrorState) {
                          return Center(
                            child: Text(
                              'Error loading recommendations: ${state.message}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  // Promoted Campaigns Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'حملات مميزة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PromotedCampaignsPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'عرض الكل',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BlocBuilder<CampaignBloc, CampaignState>(
                      buildWhen:
                          (previous, current) =>
                      current is LoadingPromotedCampaigns ||
                          current is PromotedCampaignsLoaded ||
                          current is PromotedCampaignsError,
                      builder: (context, state) {
                        if (state is LoadingPromotedCampaigns) {
                          return const Center(child: LoadingWidget());
                        } else if (state is PromotedCampaignsLoaded) {
                          // Display only the first 4 promoted campaigns
                          final displayedCampaigns =
                          state.promotedCampaigns.take(4).toList();
                          if (displayedCampaigns.isEmpty) {
                            return const Center(
                              child: Text('لا يوجد حملات مميزة بعد'),
                            );
                          }
                          return HorizontalPromotedListWidget(
                            campaigns: displayedCampaigns,
                          );
                        } else if (state is PromotedCampaignsError) {
                          return Center(
                            child: Text(
                              'Error loading promoted campaigns: ${state.message}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  // All Campaigns Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'جميع الحملات',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.WhisperWhite,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.OceanBlue.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.filter_list,
                                color: Colors.black,
                                size: 20,
                              ),
                              onPressed: _openFilterDialog,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Display selected category and clear filter button
                  if (_selectedCategoryName != null)
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'التصنيف: $_selectedCategoryName',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedCategoryName = null;
                                  _selectedCategoryId = null;
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                                context.read<CampaignBloc>().add(
                                  GetAllCampaignsEvent(),
                                );
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'إزالة الفلتر',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // All Campaigns List
                  BlocConsumer<CampaignBloc, CampaignState>(
                    listener: (context, state) {
                      if (state is AllCampaignsLoaded) {
                        _cachedAllCampaigns = state.campaigns;
                        _filterCampaigns();
                      } else if (state is CampaignsByCategoryLoaded) {
                        _cachedAllCampaigns = state.campaigns;
                        _filterCampaigns();
                      }
                    },
                    builder: (context, state) {
                      final List<Campaigns>? campaignsToDisplay;
                      if (_searchQuery.isNotEmpty) {
                        campaignsToDisplay = _filteredCampaigns;
                      } else if (_selectedCategoryId != null) {
                        campaignsToDisplay = _filteredCampaigns;
                      } else {
                        campaignsToDisplay = _cachedAllCampaigns;
                      }

                      if (state is LoadingAllCampaigns ||
                          state is LoadingCampaignsByCategory) {
                        return const SliverFillRemaining(
                          child: Center(child: LoadingWidget()),
                        );
                      } else if (campaignsToDisplay != null && campaignsToDisplay.isNotEmpty) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 6.0,
                              ),
                              child: CampaignCard(campaign:campaignsToDisplay![index]),
                            );
                          }, childCount: campaignsToDisplay.length),
                        );
                      } else if (campaignsToDisplay != null && campaignsToDisplay.isEmpty) {
                        String message = 'لا توجد حملات متاحة حالياً';
                        if (_searchQuery.isNotEmpty) {
                          message = 'لا توجد حملات مطابقة لبحثك';
                        } else if (_selectedCategoryName != null) {
                          message = 'لا توجد حملات في هذا التصنيف';
                        }
                        return SliverFillRemaining(
                          child: Center(
                            child: Text(message),
                          ),
                        );
                      } else if (state is CampaignErrorState) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      } else {
                        return const SliverFillRemaining(
                          child: Center(child: Text('جار التحميل...')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
