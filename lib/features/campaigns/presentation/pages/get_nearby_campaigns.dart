import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_color.dart';
import '../../../../navigation/main_navigation_page.dart';
import '../bloc/campaign_bloc.dart';
import '../widgets/campaign_list_widget.dart';
class GetNearbyCampaignsPage extends StatefulWidget {
  const GetNearbyCampaignsPage({Key? key}) : super(key: key);

  @override
  State<GetNearbyCampaignsPage> createState() => _GetNearbyCampaignsPageState();
}
class _GetNearbyCampaignsPageState extends State<GetNearbyCampaignsPage> {
  bool _hasInteractedWithSlider = false;
  double _selectedDistance = 2.0;
  int? _selectedCategoryId;
  final Map<String, Map<String, dynamic>> categoryIcons = {
    'تنظيف وتزيين الأماكن العامة': {
      'icon': Icons.cleaning_services,
      'color': Colors.lightBlue,
    },
    'حملات تشجير': {'icon': Icons.nature, 'color': Colors.green},
    'يوم خيري': {
      'icon': Icons.volunteer_activism,
      'color': Colors.pink,
    },
    'ترميم أضرار (كوارث , عدوان)': {
      'icon': Icons.home_repair_service,
      'color': Colors.brown,
    },
    'إنارة الشوارع بالطاقة الشمسية': {'icon': Icons.lightbulb, 'color': Colors.amber},
  };
  final Map<String, dynamic> defaultCategoryIcon = {
    'icon': Icons.category,
    'color': Colors.grey,
  };

  @override
  void initState() {
    super.initState();
  }

  void _onCategorySelected(int? id) {
    setState(() {
      _selectedCategoryId = id;
    });
  }

  void _openCategorySelector() {
    context.read<CampaignBloc>().add(GetCategoriesEvent());

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<CampaignBloc, CampaignState>(
          builder: (context, state) {
            if (state is LoadingCategories) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is CategoriesLoaded) {
              final categories = state.categories;
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'اختر تصنيف',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.all_inclusive, color: Colors.blue),
                      title: const Text('الكل'),
                      onTap: () {
                        _onCategorySelected(null);
                        Navigator.pop(context);
                      },
                    ),
                    if (categories.isNotEmpty)
                      ...categories.map((category) {
                        final iconData = categoryIcons[category.name]?['icon'] ?? defaultCategoryIcon['icon'];
                        final iconColor = categoryIcons[category.name]?['color'] ?? defaultCategoryIcon['color'];

                        return ListTile(
                          leading: Icon(iconData, color: iconColor),
                          title: Text(category.name),
                          onTap: () {
                            _onCategorySelected(category.id);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    if (categories.isEmpty && state is! LoadingCategories)
                      const Text('لا توجد تصنيفات لعرضها.'),
                  ],
                ),
              );
            } else if (state is CampaignErrorState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'حدث خطأ: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('جاري تحميل التصنيفات...'),
              ),
            );
          },
        );
      },
    );
  }

  void _searchNearbyCampaigns() {
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تصنيف')),
      );
      return;
    }
    context.read<CampaignBloc>().add(
      GetNearbyCampaignsEvent(
        categoryId: _selectedCategoryId!,
        distance: _selectedDistance,
      ),
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
            colors: [AppColors.SunsetOrange, Colors.white],
            stops: [0.0, 0.2],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
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
                                  color: AppColors.SunsetOrange.withOpacity(0.5),
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
                          'الحملات القريبة',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _openCategorySelector,
                            icon: const Icon(Icons.category),
                            label: Text(_selectedCategoryId == null ? 'اختر التصنيف' : 'تم اختيار تصنيف'),
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
                                  setState(() {
                                    _hasInteractedWithSlider = true;
                                  });
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
                            onPressed: _selectedCategoryId != null ? _searchNearbyCampaigns : null,
                            icon: const Icon(Icons.search, color: Colors.white),
                            label: const Text(
                              'عرض الحملات',
                              style: TextStyle(color: Colors.white),
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
                          const SizedBox(height: 24),
                          Expanded(
                            child: BlocBuilder<CampaignBloc, CampaignState>(
                              builder: (context, state) {
                                if (state is LoadingNearbyCampaigns) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (state is NearbyCampaignsLoaded) {
                                  if (state.nearbyCampaigns.isEmpty) {
                                    return const Center(child: Text('لا توجد حملات قريبة'));
                                  }
                                  return CampaignListWidget(campaigns: state.nearbyCampaigns);
                                } else if (state is NearbyCampaignsError) {
                                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
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
    );
  }
}