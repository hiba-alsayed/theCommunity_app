import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/notifications/presentation/page/notification_page.dart';
import 'package:graduation_project/features/suggestions/presentation/pages/submit_suggestion_page.dart';
import '../../../../navigation/bottom_bar.dart';
import '../../../../core/widgets/gradiant_app_bar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/message_display_widget.dart';
import '../widgets/suggestions_list_widget.dart';
import '../bloc/suggestion_bloc.dart';

class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({super.key});

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  String? _selectedCategory;
  int? _selectedCategoryId;

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

  @override
  void initState() {
    super.initState();
    context.read<SuggestionBloc>().add(GetAllSuggestionsEvent());

  }

  void _loadCategorySuggestions(int? categoryId) {
    if (categoryId == null) {
      context.read<SuggestionBloc>().add(GetAllSuggestionsEvent());
    } else {
      context.read<SuggestionBloc>().add(
        LoadSuggestionsByCategoryEvent(categoryId),
      );
    }
  }

  void _showCategoryFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
              // All categories option
              ListTile(
                leading: const Icon(Icons.all_inclusive, color: Colors.blue),
                title: const Text('الكل'),
                onTap: () {
                  setState(() {
                    _selectedCategory = null;
                    _selectedCategoryId = null;
                  });
                  _loadCategorySuggestions(null);
                  Navigator.pop(context);
                },
              ),
              ..._categoriesWithIcons.entries.map((entry) {
                return ListTile(
                  leading: Icon(
                    entry.value['icon'],
                    color: entry.value['color'],
                  ),
                  title: Text(entry.key),
                  onTap: () {
                    setState(() {
                      _selectedCategory = entry.key;
                      _selectedCategoryId = entry.value['id'];
                    });
                    _loadCategorySuggestions(entry.value['id']);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showCategoryFilterMenu(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFD2D2D2),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.filter_list,
                              color: Color(0xFF00B4D8),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'التصويت على المقترحات',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Add Suggestion Button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SubmitSuggestionPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFD2D2D2),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Color(0xFF00B4D8),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedCategory != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, size: 20,
                          color: Color(0xFF00B4D8)),
                      onPressed: () {
                        setState(() {
                          _selectedCategory = null;
                          _selectedCategoryId = null;
                        });
                        _loadCategorySuggestions(null);
                      },
                    ),
                    Text(
                      'التصنيف: $_selectedCategory',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: BlocConsumer<SuggestionBloc, SuggestionState>(
                listener: (context, state) {
                  if (state is VoteOnSuggestionSuccess ||
                      state is SuggestionSubmittedSuccessState ||
                      state is VoteOnSuggestionFailure ||
                      state is SuggestionSubmittedErrorState) {
                    if (_selectedCategoryId != null) {
                      context.read<SuggestionBloc>().add(
                        LoadSuggestionsByCategoryEvent(_selectedCategoryId!),
                      );
                    } else {
                      context.read<SuggestionBloc>().add(
                        GetAllSuggestionsEvent(),
                      );
                    }
                  }
                },
                builder: (context, state) {
                  if (state is LoadingAllSuggestions ||
                      state is LoadingSuggestionsByCategory) {
                    return const LoadingWidget();
                  } else if (state is AllSuggestionsLoaded) {
                    debugPrint(
                      "Suggestions Loaded: ${state.suggestion.length}",
                    );

                    final suggestions =
                        _selectedCategoryId == null
                            ? state.suggestion
                            : state.suggestion
                                .where((s) => s.category == _selectedCategoryId)
                                .toList();

                    return suggestions.isEmpty
                        ? const MessageDisplayWidget(
                          message: 'لا توجد مقترحات في هذا التصنيف',
                        )
                        : SuggestionsListWidget(suggestion: suggestions, isMySuggestionsPage: false, );
                  } else if (state is SuggestionsByCategoryLoaded) {
                    return state.suggestions.isEmpty
                        ? const MessageDisplayWidget(
                          message: 'لا توجد مقترحات في هذا التصنيف',
                        )
                        : SuggestionsListWidget(suggestion: state.suggestions, isMySuggestionsPage: false,);
                  } else if (state is SuggestionErrorState) {
                    debugPrint("Error: ${state.message}");
                    return MessageDisplayWidget(message: state.message);
                  }
                  return const MessageDisplayWidget(message: 'لا توجد بيانات');
                },
              ),
            ),
          ],

        ),
      ),
    );
  }
}
