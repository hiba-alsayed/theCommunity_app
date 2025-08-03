import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/complaints/domain/entites/complaint.dart';
import 'package:graduation_project/features/complaints/presentation/bloc/complaint_bloc.dart';
import 'package:graduation_project/features/complaints/presentation/pages/submit_complaint_page.dart';
import '../../../../core/app_color.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../notifications/presentation/page/notification_page.dart';
import '../widgets/complaint_list_widget.dart';
import '../widgets/nearby_complaint_carousel_widget.dart';
import 'all_nearby_complaints_page.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  String? _selectedCategoryName;
  List<ComplaintEntity>? _cachedAllComplaints;
  List<ComplaintEntity>? _filteredComplaints;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _refreshComplaints();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshComplaints() async {
    context.read<ComplaintBloc>().add(GetAllNearbyComplaintsEvent());
    context.read<ComplaintBloc>().add(GetAllComplaintsEvent());
  }

  void _onSearchChanged() {
    _filterComplaints(_searchController.text);
  }

  void _filterComplaints(String query) {
    if (_cachedAllComplaints == null) {
      _filteredComplaints = null;
      return;
    }

    if (query.isEmpty) {
      setState(() {
        _filteredComplaints = List.from(_cachedAllComplaints!);
      });
      return;
    }

    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      _filteredComplaints = _cachedAllComplaints!.where((complaint) {
        final title = complaint.title.toLowerCase() ?? '';
        final description = complaint.description.toLowerCase() ?? '';
        return title.contains(lowerCaseQuery) || description.contains(lowerCaseQuery);
      }).toList();
    });
  }

  void _navigateToSubmitComplaint() async {
    final complaintBloc = context.read<ComplaintBloc>();
    complaintBloc.add(GetCategoriesEvent());
    complaintBloc.add(GetAllRegionsEvent());
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SubmitComplaintPage()),
    );
    context.read<ComplaintBloc>().add(GetAllComplaintsEvent());
  }

  void _openFilterDialog() {
    context.read<ComplaintBloc>().add(GetCategoriesEvent());
    showModalBottomSheet(
      context: context,
      builder: (bContext) {
        return BlocBuilder<ComplaintBloc, ComplaintState>(
          bloc: BlocProvider.of<ComplaintBloc>(context),
          builder: (context, state) {
            if (state is LoadingCategories) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: LoadingWidget(),
                ),
              );
            } else if (state is CategoriesLoaded) {
              final categories = state.categories;
              final Map<String, Map<String, dynamic>> categoryIcons = {
                'نظافة': {'icon': Icons.cleaning_services, 'color': Colors.lightBlue},
                'صيانة': {'icon': Icons.build, 'color': Colors.green},
                'انارة': {'icon': Icons.lightbulb, 'color': Colors.yellow.shade700},
                'كهرباء': {'icon': Icons.electrical_services, 'color': Colors.deepOrange},
                'صرف صحي': {'icon': Icons.water_damage, 'color': Colors.deepPurpleAccent},
                'مياه': {'icon': Icons.water, 'color': Colors.blue},
                'ارصفة و طرقات': {'icon': Icons.edit_road, 'color': Colors.black},
                'أخرى': {'icon': Icons.category, 'color': Colors.grey},
              };

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('اختر تصنيف', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.all_inclusive, color: Colors.blue),
                        title: const Text('الكل'),
                        onTap: () {
                          setState(() { _selectedCategoryName = null; });
                          context.read<ComplaintBloc>().add(GetAllComplaintsEvent());
                          Navigator.pop(bContext);
                        },
                      ),
                      ...categories.map((category) {
                        final iconData = categoryIcons[category.name] ?? {'icon': Icons.category, 'color': Colors.grey};
                        return ListTile(
                          leading: Icon(iconData['icon'], color: iconData['color']),
                          title: Text(category.name),
                          onTap: () {
                            setState(() { _selectedCategoryName = category.name; });
                            context.read<ComplaintBloc>().add(GetComplaintsByCategoryEvent(category.categoryId));
                            Navigator.pop(bContext);
                          },
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            } else if (state is ComplaintErrorState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('حدث خطأ: ${state.message}', style: const TextStyle(color: Colors.red)),
              );
            }
            return const Center(child: Padding(padding: EdgeInsets.all(20.0), child: LoadingWidget()));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.RichBerry, Colors.white],
            stops: [0.0, 0.2],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshComplaints,
            color: AppColors.RichBerry,
            backgroundColor: AppColors.WhisperWhite,
            child: CustomScrollView(
              slivers: [
                // Top Bar: Notification, Search, submit complaint
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
                                color: AppColors.RichBerry.withOpacity(0.5),
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
                                    color: AppColors.RichBerry,
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
                              cursorColor: AppColors.OliveMid,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.WhisperWhite,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.RichBerry.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 20,
                              ),
                              onPressed: _navigateToSubmitComplaint
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                          'شكاوى قريبة منك',
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
                                builder: (_) => AllNearbyComplaintsPage(),
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
                  child: BlocBuilder<ComplaintBloc, ComplaintState>(
                    buildWhen:
                        (previous, current) =>
                    current is LoadingAllNearbyComplaints ||
                        current is AllNearbyComplaintsLoaded ||
                        current is ComplaintErrorState,
                    builder: (context, state) {
                      if (state is LoadingAllNearbyComplaints) {
                        return const Center(
                          child: LoadingWidget(),
                        );
                      } else if (state is AllNearbyComplaintsLoaded) {
                        final displayedCampaigns =
                        state.complaints.take(4).toList();
                        if (displayedCampaigns.isEmpty) {
                          return const Center(child: Text('لا يوجد شكاوى بعد'));
                        }
                        return NearbyComplaintCarouselWidget(
                          complaint: displayedCampaigns,
                        );
                      } else if (state is ComplaintErrorState) {
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'جميع الشكاوي',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.WhisperWhite,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.OliveMid.withOpacity(0.5),
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

                      ],
                    ),
                  ),
                ),
                if (_selectedCategoryName != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),                           child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategoryName = null;
                                _searchController.clear();
                              });
                              context.read<ComplaintBloc>().add(
                                GetAllComplaintsEvent(),
                              );
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: AppColors.RichBerry,
                            ),
                          ),
                          Text(
                            'التصنيف: $_selectedCategoryName',
                            style: const TextStyle(
                              fontSize: 14,
                                color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                BlocConsumer<ComplaintBloc, ComplaintState>(
                  listener: (context, state) {
                    // Cache campaigns when loaded
                    if (state is ComplaintsLoaded) {
                      _cachedAllComplaints = state.complaints;
                      _filterComplaints(_searchController.text);
                    } else if (state is ComplaintsByCategoryLoaded) {
                      _cachedAllComplaints = state.complaints;
                      _filterComplaints(_searchController.text);
                    }
                  },
                  builder: (context, state) {
                    final List<ComplaintEntity>? complaintsToDisplay =
                    _searchController.text.isNotEmpty || _selectedCategoryName != null
                        ? _filteredComplaints
                        : _cachedAllComplaints;

                    if (state is LoadingComplaints ||
                        state is LoadingComplaintsByCategory) {
                      return const SliverFillRemaining(
                        child: Center(child: LoadingWidget()),
                      );
                    } else if (complaintsToDisplay != null && complaintsToDisplay.isNotEmpty) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                            child: ComplaintCard(complaint: complaintsToDisplay[index]),
                          );
                        }, childCount: complaintsToDisplay.length),
                      );
                    } else if (state is ComplaintErrorState) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    } else {
                      String message = 'لا توجد شكاوى لعرضها.';
                      if (_searchController.text.isNotEmpty && _filteredComplaints?.isEmpty == true) {
                        message = 'لا توجد شكاوى مطابقة لبحثك.';
                      } else if (_selectedCategoryName != null && _filteredComplaints?.isEmpty == true) {
                        message = 'لا توجد شكاوى في هذا التصنيف.';
                      }
                      return SliverFillRemaining(
                        child: Center(child: Text(message)),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
