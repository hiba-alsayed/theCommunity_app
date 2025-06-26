import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import '../../../../core/app_color.dart';
import '../../domain/entities/campaigns.dart';
import '../bloc/campaign_bloc.dart';
import '../widgets/campaign_list_widget.dart';

class CampaignsPage extends StatefulWidget {
  const CampaignsPage({super.key});

  @override
  State<CampaignsPage> createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage> {
  String? _selectedCategory;
  int? _selectedCategoryId;
  List<Campaigns>? _cachedCampaigns;
  @override
  void initState() {
    super.initState();
    final bloc = context.read<CampaignBloc>();
    bloc.add(GetAllCampaignsEvent());
  }

  void _openFilterDialog() {
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
                    ListTile(
                      leading: const Icon(
                        Icons.all_inclusive,
                        color: Colors.blue,
                      ),
                      title: const Text('الكل'),
                      onTap: () {
                        context.read<CampaignBloc>().add(
                          GetAllCampaignsEvent(),
                        );
                        Navigator.pop(context);
                      },
                    ),
                    ...categories.map((category) {
                      final match = categoryIcons.entries.firstWhere(
                        (entry) => category.name.contains(entry.key),
                        orElse:
                            () => MapEntry('', {
                              'icon': Icons.category,
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
                          context.read<CampaignBloc>().add(
                            GetAllCampaignsByCategoryEvent(category.id),
                          );
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
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
            return const SizedBox.shrink();
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
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'جميع الحملات',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  if (_selectedCategory != null)
                    Container(
                      color: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'التصنيف: $_selectedCategory',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _selectedCategory = null;
                                _selectedCategoryId = null;
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
                  Expanded(
                    child: BlocConsumer<CampaignBloc, CampaignState>(
                      listener: (context, state) {
                        if (state is AllCampaignsLoaded) {
                          _cachedCampaigns = state.campaigns;
                        }
                      },
                      builder: (context, state) {
                        if (state is LoadingAllCampaigns ||
                            state is LoadingCampaignsByCategory) {
                          return const Center(child: LoadingWidget());
                        } else if (state is AllCampaignsLoaded) {
                          _cachedCampaigns = state.campaigns;
                          if (state.campaigns.isEmpty) {
                            return const Center(
                              child: Text('لا توجد حملات متاحة حالياً'),
                            );
                          }
                          return CampaignListWidget(campaigns: state.campaigns);
                        } else if (state is CampaignsByCategoryLoaded) {
                          if (state.campaigns.isEmpty) {
                            return const Center(
                              child: Text('لا توجد حملات في هذا التصنيف'),
                            );
                          }
                          return CampaignListWidget(campaigns: state.campaigns);
                        } else if (_cachedCampaigns != null &&
                            _cachedCampaigns!.isNotEmpty) {
                          return CampaignListWidget(
                            campaigns: _cachedCampaigns!,
                          );
                        } else if (state is CampaignErrorState) {
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else {
                          return const Center(child: Text('جار التحميل...'));
                        }
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 12,
                right: 12,
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
                    onPressed: _openFilterDialog,
                    icon: const Icon(Icons.filter_list, color: Colors.black),
                    tooltip: 'فلترة الحملات',
                    //elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
