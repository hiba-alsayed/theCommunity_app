import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_color.dart';
import '../../../../navigation/main_navigation_page.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/suggestion_bloc.dart';
import '../widgets/suggestions_list_widget.dart';

class NearbySuggestionsScreen extends StatefulWidget {
  const NearbySuggestionsScreen({Key? key}) : super(key: key);

  @override
  State<NearbySuggestionsScreen> createState() => _NearbySuggestionsScreenState();
}
class _NearbySuggestionsScreenState extends State<NearbySuggestionsScreen> {
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

  void _fetchCategories() {
    context.read<SuggestionBloc>().add(LoadSuggestionCategoriesEvent());
  }

  void _onCategorySelected(int? id) {
    setState(() {
      _selectedCategoryId = id;
    });
  }

  void _openCategorySelector() {
    _fetchCategories();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<SuggestionBloc, SuggestionState>(
          builder: (context, state) {
            if (state is LoadingSuggestionCategories) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is SuggestionCategoriesLoaded) {
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
                    if (categories.isEmpty && state is! LoadingSuggestionCategories)
                      const Text('لا توجد تصنيفات لعرضها.'),
                  ],
                ),
              );
            } else if (state is SuggestionCategoryError) {
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

  void _searchNearbySuggestions() {
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تصنيف')),
      );
      return;
    }
    context.read<SuggestionBloc>().add(
      GetNearbySuggestionsEvent(
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
            colors: [AppColors.OceanBlue, Colors.white],
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
                                  color: AppColors.OceanBlue.withOpacity(0.5),
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
                          "المبادرات القريبة",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
                            onPressed: _selectedCategoryId != null ? _searchNearbySuggestions : null,
                            icon: const Icon(Icons.search, color: Colors.white),
                            label: const Text(
                              'عرض المبادرات',
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
                            child: BlocBuilder<SuggestionBloc, SuggestionState>(
                              builder: (context, state) {
                                if (state is SuggestionsLoading) {
                                  return const Center(child: LoadingWidget());
                                } else if (state is SuggestionsLoaded) {
                                  if (state.suggestions.isEmpty) {
                                    return const Center(child: Text('لا توجد مبادرات قريبة'));
                                  }
                                  return SuggestionsListWidget(suggestion: state.suggestions, isMySuggestionsPage: false,);
                                } else if (state is SuggestionsError) {
                                  return Center(child: Text(state.message));
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