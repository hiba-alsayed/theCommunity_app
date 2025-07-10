import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/suggestions/domain/entities/Suggestions.dart';
import '../../../../core/app_color.dart'; // Make sure this import is correct for AppColors
import '../../../../navigation/main_navigation_page.dart'; // Import MainNavigationPage
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
  final Map<String, Map<String, dynamic>> _categoriesWithIcons = {
    'إضاءة شوارع بالطاقة الشمسية': {
      'id': 1,
      'icon': Icons.lightbulb,
      'color': Colors.amber,
    },
    'تنظيف وتجميل الأماكن العامة': {
      'id': 2,
      'icon': Icons.cleaning_services,
      'color': Colors.lightBlue,
    },
    'يوم خيري': {
      'id': 3,
      'icon': Icons.volunteer_activism,
      'color': Colors.pink,
    },
    'حملات تشجير': {'id': 4, 'icon': Icons.nature, 'color': Colors.green},
    'ترميم الأضرار (كوارث، اعتداءات)': {
      'id': 5,
      'icon': Icons.home_repair_service,
      'color': Colors.brown,
    },
  };
  String? _selectedCategory;
  double _selectedDistance = 2.0;

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
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'اختر التصنيف',
                                labelStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF848484),
                                ),
                                border: OutlineInputBorder(),
                              ),
                              items: _categoriesWithIcons.entries.map((entry) {
                                return DropdownMenuItem<String>(
                                  value: entry.key,
                                  child: Row(
                                    children: [
                                      Icon(entry.value['icon'], color: entry.value['color']),
                                      SizedBox(width: 8),
                                      Text(entry.key),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                              value: _selectedCategory,
                            ),
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'اختر المسافة (كم): ${_selectedDistance.toStringAsFixed(1)}',
                                style: TextStyle(
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
                                  activeColor: _hasInteractedWithSlider ? Color(0xFF0172B2) : Colors.grey,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedDistance = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _selectedCategory != null
                                ? () {
                              final categoryId = _categoriesWithIcons[_selectedCategory]!['id'];
                              context.read<SuggestionBloc>().add(
                                GetNearbySuggestionsEvent(
                                  categoryId: categoryId,
                                  distance: _selectedDistance,
                                ),
                              );
                            }
                                : null,
                            icon: Icon(Icons.search, color: Colors.white),
                            label: Text(
                              'عرض المبادرات',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0172B2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              elevation: 3,
                            ),
                          ),
                          SizedBox(height: 24),
                          Expanded(
                            child: BlocBuilder<SuggestionBloc, SuggestionState>(
                              builder: (context, state) {
                                if (state is SuggestionsLoading) {
                                  return Center(child: LoadingWidget());
                                } else if (state is SuggestionsLoaded) {
                                  if (state.suggestions.isEmpty) {
                                    return Center(child: Text('لا توجد مبادرات قريبة'));
                                  }
                                  return SuggestionsListWidget(suggestion: state.suggestions, isMySuggestionsPage: false,);
                                } else if (state is SuggestionsError) {
                                  return Center(child: Text(state.message));
                                }
                                return Center(child: Text('اختر تصنيفًا ومسافة لعرض النتائج'));
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