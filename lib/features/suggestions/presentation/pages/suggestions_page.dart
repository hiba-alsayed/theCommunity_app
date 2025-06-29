import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/suggestions/presentation/pages/submit_suggestion_page.dart';
import '../../../../core/app_color.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/message_display_widget.dart';
import '../../domain/entities/Suggestions.dart';
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

  List<Suggestions>? _currentSuggestions;

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
    context.read<SuggestionBloc>().add(LoadSuggestionCategoriesEvent());
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<SuggestionBloc, SuggestionState>(
          builder: (context, state) {
            if (state is LoadingSuggestionCategories) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
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
                        setState(() {
                          _selectedCategory = null;
                          _selectedCategoryId = null;
                        });
                        _loadCategorySuggestions(null);
                        Navigator.pop(context);
                      },
                    ),
                    ...categories.map((category) {
                      final matchingEntry = categoryIcons.entries.firstWhere(
                            (entry) => category.name.contains(entry.key),
                        orElse: () => MapEntry('', {
                          'icon': Icons.category,
                          'color': Colors.grey,
                        }),
                      );

                      final iconData = matchingEntry.value['icon'];
                      final iconColor = matchingEntry.value['color'];

                      return ListTile(
                        leading: Icon(iconData, color: iconColor),
                        title: Text(category.name),
                        onTap: () {
                          setState(() {
                            _selectedCategory = category.name;
                            _selectedCategoryId = category.id;
                          });
                          _loadCategorySuggestions(category.id);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ],
                ),
              );
            } else if (state is SuggestionCategoryError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox(
              height: 200,
              child: Center(child: Text('حدث خطأ في تحميل التصنيفات.')),
            );
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
            colors: [AppColors.OceanBlue, Colors.white],
            stops: [0.0, 0.2],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                                color: AppColors.OceanBlue.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.filter_list, color: Colors.black, size: 20),
                            onPressed: () => _showCategoryFilterMenu(context),
                          ),
                        ),
                        const SizedBox(width: 65),
                        const Text(
                          'التصويت على المقترحات',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
                        icon: const Icon(Icons.add, color: Colors.black, size: 20),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SubmitSuggestionPage(),
                            ),
                          );
                        },
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
                        icon: const Icon(Icons.close, size: 20, color: Color(0xFF00B4D8)),
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
                    if (state is AllSuggestionsLoaded) {
                      _currentSuggestions = state.suggestion;
                    } else if (state is SuggestionsByCategoryLoaded) {
                      _currentSuggestions = state.suggestions;
                    }
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
                      // عندما تكون كل المقترحات محملة، قم بعرضها
                      if (state.suggestion.isEmpty) {
                        return const MessageDisplayWidget(message: 'لا توجد مقترحات متاحة حالياً.');
                      }
                      return SuggestionsListWidget(suggestion: state.suggestion, isMySuggestionsPage: false);
                    } else if (state is SuggestionsByCategoryLoaded) {
                      if (state.suggestions.isEmpty) {
                        return const MessageDisplayWidget(message: 'لا توجد مقترحات في هذا التصنيف.');
                      }
                      return SuggestionsListWidget(suggestion: state.suggestions, isMySuggestionsPage: false);
                    } else if (state is SuggestionErrorState) {
                      return MessageDisplayWidget(message: state.message);
                    }
                    else if (_currentSuggestions != null && _currentSuggestions!.isNotEmpty) {
                      return SuggestionsListWidget(suggestion: _currentSuggestions!, isMySuggestionsPage: false);
                    }
                    return const MessageDisplayWidget(message: 'جارِ تحميل المقترحات...');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}