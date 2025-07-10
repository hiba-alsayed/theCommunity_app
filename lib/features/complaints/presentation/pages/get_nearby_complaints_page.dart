import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_color.dart';
import '../../../../navigation/main_navigation_page.dart';
import '../bloc/complaint_bloc.dart';
import '../../domain/entites/complaint_category_entity.dart';
import '../widgets/complaint_list_widget.dart';

class GetNearbyComplaintsPage extends StatefulWidget {
  const GetNearbyComplaintsPage({Key? key}) : super(key: key);

  @override
  State<GetNearbyComplaintsPage> createState() => _GetNearbyComplaintsPageState();
}

class _GetNearbyComplaintsPageState extends State<GetNearbyComplaintsPage> {
  bool _hasInteractedWithSlider = false;
  double _selectedDistance = 2.0;
  int? _selectedCategoryId;
  ComplaintCategory? _selectedCategory;
  List<ComplaintCategory> _availableCategories = [];

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

  @override
  void initState() {
    super.initState();
    context.read<ComplaintBloc>().add(GetCategoriesEvent());
  }

  void _onCategorySelected(ComplaintCategory category) {
    setState(() {
      _selectedCategory = category;
      _selectedCategoryId = category.categoryId;
    });
  }

  void _openCategorySelector() {
    if (_availableCategories.isEmpty) {
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'اختر تصنيف الشكوى',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: _availableCategories.map((category) {
                    final iconInfo = categoryIcons[category.name] ?? categoryIcons['أخرى']!;
                    final IconData icon = iconInfo['icon'] as IconData;
                    final Color color = iconInfo['color'] as Color;

                    return ListTile(
                      leading: Icon(icon, color: color, size: 28),
                      title: Text(category.name, style: const TextStyle(fontSize: 16)),
                      onTap: () {
                        _onCategorySelected(category);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _searchNearbyComplaints() {
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تصنيف أولاً')),
      );
      return;
    }
    context.read<ComplaintBloc>().add(
      GetNearbyComplaintsEvent(
        _selectedDistance,
        _selectedCategoryId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ComplaintBloc, ComplaintState>(
      listener: (context, state) {
        if (state is CategoriesLoaded) {
          setState(() {
            _availableCategories = state.categories;
          });
        }
      },
      child: Scaffold(
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
            child: Stack(
              children: [
                Column(
                  children: [
                    // --- Custom Header ---
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 20.0,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
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
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const MainNavigationPage(),
                                    ),
                                  );
                                },
                                tooltip: 'العودة',
                              ),
                            ),
                          ),
                          const Text(
                            "الشكاوى القريبة",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // --- End Custom Header ---

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _availableCategories.isNotEmpty ? _openCategorySelector : null,
                              icon: Icon(
                                _selectedCategory == null
                                    ? Icons.category
                                    : (categoryIcons[_selectedCategory!.name] ?? categoryIcons['أخرى']!)['icon'] as IconData,
                                color: Colors.white,
                              ),
                              label: Text(
                                _selectedCategory == null ? 'اختر التصنيف' : _selectedCategory!.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0172B2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                elevation: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'اختر المسافة (كم): ${_selectedDistance.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF848484),
                                  ),
                                ),
                                Listener(
                                  onPointerDown: (_) {
                                    if (!_hasInteractedWithSlider) {
                                      setState(() {
                                        _hasInteractedWithSlider = true;
                                      });
                                    }
                                  },
                                  child: Slider(
                                    value: _selectedDistance,
                                    min: 1.0,
                                    max: 20.0,
                                    divisions: 19,
                                    label: '${_selectedDistance.toStringAsFixed(1)} كم',
                                    activeColor: _hasInteractedWithSlider ? const Color(0xFF0172B2) : Colors.grey,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDistance = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _selectedCategoryId != null ? _searchNearbyComplaints : null,
                              icon: const Icon(Icons.search, color: Colors.white),
                              label: const Text(
                                'عرض الشكاوى',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0172B2),
                                disabledBackgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                elevation: 3,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Expanded(
                              child: BlocBuilder<ComplaintBloc, ComplaintState>(
                                builder: (context, state) {
                                  if (state is LoadingNearbyComplaints) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (state is NearbyComplaintsLoaded) {
                                    if (state.complaints.isEmpty) {
                                      return const Center(child: Text('لا توجد شكاوى قريبة ضمن هذا النطاق'));
                                    }
                                    return ComplaintListView(complaints: state.complaints);
                                  } else if (state is ComplaintErrorState) {
                                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                                  } else if (state is LoadingCategories) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  return const Center(child: Text('اختر تصنيفًا ومسافة لعرض النتائج'));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}