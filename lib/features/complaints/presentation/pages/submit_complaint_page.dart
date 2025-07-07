// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:graduation_project/features/complaints/domain/entites/complaint_category_entity.dart';
// import '../../../../core/widgets/loading_widget.dart';
// import '../../../../core pages/location_picker_page.dart';
// import '../../domain/entites/regions_entity.dart';
// import '../bloc/complaint_bloc.dart';
//
//
// class SubmitComplaintPage extends StatefulWidget {
//   const SubmitComplaintPage({super.key});
//
//   @override
//   _SubmitComplaintPageState createState() => _SubmitComplaintPageState();
// }
//
// class _SubmitComplaintPageState extends State<SubmitComplaintPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//
//   List<File> _complaintImages = [];
//   ComplaintCategory? _selectedCategory;
//   RegionEntity? _selectedRegion;
//   LatLng? _selectedLocation;
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImages() async {
//     final List<XFile> pickedFiles = await _picker.pickMultiImage(
//       imageQuality: 80,
//     );
//     if (pickedFiles.isNotEmpty) {
//       setState(() {
//         _complaintImages.addAll(pickedFiles.map((file) => File(file.path)));
//       });
//     }
//   }
//
//   void _removeImage(int index) {
//     setState(() {
//       _complaintImages.removeAt(index);
//     });
//   }
//
//   // --- MODIFICATION 1: Correctly handle the returned result ---
//   void _navigateAndPickLocation() async {
//     // Navigate and wait for a result.
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const LocationPickerPage()),
//     );
//
//     // Check if the result is a Map and contains the 'location' key.
//     if (result != null && result is Map && result.containsKey('location')) {
//       setState(() {
//         // Extract the LatLng object from the Map.
//         _selectedLocation = result['location'] as LatLng;
//       });
//     }
//   }
//
//   void _submitComplaint() {
//     if (_formKey.currentState!.validate()) {
//       if (_selectedCategory == null) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار تصنيف الشكوى')));
//         return;
//       }
//       if (_selectedRegion == null) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار المنطقة')));
//         return;
//       }
//       if (_selectedLocation == null) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار الموقع من الخريطة')));
//         return;
//       }
//       if (_complaintImages.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إضافة صورة واحدة على الأقل للشكوى')));
//         return;
//       }
//
//       context.read<ComplaintBloc>().add(
//         SubmitComplaintEvent(
//           title: _titleController.text,
//           description: _descriptionController.text,
//           area: _selectedRegion!.name,
//           latitude: _selectedLocation!.latitude,
//           longitude: _selectedLocation!.longitude,
//           complaintCategoryId: _selectedCategory!.categoryId,
//           complaintImages: _complaintImages,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('تقديم شكوى جديدة'),
//           centerTitle: true,
//         ),
//         body: BlocConsumer<ComplaintBloc, ComplaintState>(
//           listener: (context, state) {
//             if (state is ComplaintErrorState) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('خطأ: ${state.message}'), backgroundColor: Colors.red),
//               );
//             } else if (state is ComplaintSubmittedSuccessfully) {
//               showDialog(
//                 context: context,
//                 barrierDismissible: false, // Prevent dismissing by tapping outside
//                 builder: (dialogContext) => AlertDialog(
//                   title: const Text("تم إرسال الشكوى بنجاح"),
//                   content: const Text("شكراً لك، سيتم مراجعة الشكوى من قبل الجهات المختصة."),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         // --- CHANGE IS HERE ---
//                         // First, pop the dialog
//                         Navigator.of(dialogContext).pop();
//                         // Then, pop the SubmitComplaintPage and return 'true' to signal success
//                         Navigator.of(context).pop(true);
//                       },
//                       child: const Text("حسناً"),
//                     ),
//                   ],
//                 ),
//               );
//             }
//           },
//           builder: (context, state) {
//             //... (the rest of your builder code remains the same)
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildFormField(
//                       controller: _titleController,
//                       label: 'عنوان الشكوى',
//                       icon: Icons.title,
//                     ),
//                     const SizedBox(height: 16),
//                     BlocBuilder<ComplaintBloc, ComplaintState>(
//                       buildWhen: (previous, current) => current is CategoriesLoaded || current is LoadingCategories,
//                       builder: (context, state) {
//                         if (state is CategoriesLoaded) {
//                           return _buildCategoryDropdown(state.categories);
//                         }
//                         return _buildLoadingDropdown('جاري تحميل التصنيفات...');
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     BlocBuilder<ComplaintBloc, ComplaintState>(
//                       buildWhen: (previous, current) => current is RegionsLoaded || current is LoadingRegions,
//                       builder: (context, state) {
//                         if (state is RegionsLoaded) {
//                           return _buildRegionDropdown(state.regions);
//                         }
//                         return _buildLoadingDropdown('جاري تحميل المناطق...');
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     _buildLocationPicker(),
//                     const SizedBox(height: 16),
//                     _buildFormField(
//                       controller: _descriptionController,
//                       label: 'وصف الشكوى',
//                       icon: Icons.description,
//                       maxLines: 4,
//                     ),
//                     const SizedBox(height: 24),
//                     const Text('صور الشكوى', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     _buildImagePicker(),
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                         ),
//                         onPressed: state is SubmittingComplaint ? null : _submitComplaint,
//                         icon: const Icon(Icons.send),
//                         label: state is SubmittingComplaint
//                             ? const LoadingWidget()
//                             : const Text('تقديم الشكوى', style: TextStyle(fontSize: 18)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   //... (all your helper widgets like _buildFormField, etc. remain the same)
//   Widget _buildFormField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     int maxLines = 1,
//   }) {
//     return TextFormField(
//       controller: controller,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         border: const OutlineInputBorder(),
//       ),
//       validator: (value) => value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
//     );
//   }
//
//   Widget _buildCategoryDropdown(List<ComplaintCategory> categories) {
//     return DropdownButtonFormField<ComplaintCategory>(
//       value: _selectedCategory,
//       decoration: const InputDecoration(
//         labelText: 'تصنيف الشكوى',
//         prefixIcon: Icon(Icons.category),
//         border: OutlineInputBorder(),
//       ),
//       items: categories.map((category) {
//         return DropdownMenuItem<ComplaintCategory>(
//           value: category,
//           child: Text(category.name),
//         );
//       }).toList(),
//       onChanged: (value) {
//         setState(() {
//           _selectedCategory = value;
//         });
//       },
//       validator: (value) => value == null ? 'الرجاء اختيار التصنيف' : null,
//     );
//   }
//
//   Widget _buildRegionDropdown(List<RegionEntity> regions) {
//     return DropdownButtonFormField<RegionEntity>(
//       value: _selectedRegion,
//       decoration: const InputDecoration(
//         labelText: 'المنطقة',
//         prefixIcon: Icon(Icons.map_outlined),
//         border: OutlineInputBorder(),
//       ),
//       items: regions.map((region) {
//         return DropdownMenuItem<RegionEntity>(
//           value: region,
//           child: Text(region.name),
//         );
//       }).toList(),
//       onChanged: (value) {
//         setState(() {
//           _selectedRegion = value;
//         });
//       },
//       validator: (value) => value == null ? 'الرجاء اختيار المنطقة' : null,
//     );
//   }
//
//   // --- NEW HELPER FOR A BETTER LOADING UI ---
//   Widget _buildLoadingDropdown(String label) {
//     return TextFormField(
//       readOnly: true,
//       decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: const Icon(Icons.hourglass_top),
//           border: const OutlineInputBorder(),
//           suffixIcon: const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: CircularProgressIndicator(strokeWidth: 2),
//           )
//       ),
//     );
//   }
//
//
//   Widget _buildLocationPicker() {
//     return Row(
//       children: [
//         const Icon(Icons.location_on, color: Colors.grey),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             _selectedLocation == null
//                 ? 'لم يتم تحديد الموقع على الخريطة'
//                 : 'تم تحديد الموقع بنجاح',
//             style: TextStyle(
//               color: _selectedLocation == null ? Colors.grey.shade600 : Colors.green.shade700,
//             ),
//           ),
//         ),
//         TextButton(
//           onPressed: _navigateAndPickLocation,
//           child: const Text('اختر من الخريطة'),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildImagePicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (_complaintImages.isNotEmpty)
//           SizedBox(
//             height: 100,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: _complaintImages.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: Image.file(
//                           _complaintImages[index],
//                           height: 100,
//                           width: 100,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: GestureDetector(
//                           onTap: () => _removeImage(index),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.6),
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(Icons.close, color: Colors.white, size: 18),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         const SizedBox(height: 8),
//         OutlinedButton.icon(
//           onPressed: _pickImages,
//           icon: const Icon(Icons.add_a_photo),
//           label: const Text('أضف صورة'),
//         ),
//       ],
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Added for animations
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graduation_project/features/complaints/domain/entites/complaint_category_entity.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core pages/location_picker_page.dart';
import '../../../../navigation/main_navigation_page.dart'; // Added for back navigation
import '../../domain/entites/regions_entity.dart';
import '../bloc/complaint_bloc.dart';
import 'package:graduation_project/core/app_color.dart'; // Assuming this defines AppColors.OceanBlue

class SubmitComplaintPage extends StatefulWidget {
  const SubmitComplaintPage({super.key});

  @override
  _SubmitComplaintPageState createState() => _SubmitComplaintPageState();
}

class _SubmitComplaintPageState extends State<SubmitComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<File> _complaintImages = [];
  ComplaintCategory? _selectedCategory;
  RegionEntity? _selectedRegion;
  LatLng? _selectedLocation;
  final ImagePicker _picker = ImagePicker();



  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage(
      imageQuality: 80,
    );
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _complaintImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _complaintImages.removeAt(index);
    });
  }

  void _navigateAndPickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
    );

    if (result != null && result is Map && result.containsKey('location')) {
      setState(() {
        _selectedLocation = result['location'] as LatLng;
      });
    }
  }

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار تصنيف الشكوى')));
        return;
      }
      if (_selectedRegion == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار المنطقة')));
        return;
      }
      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار الموقع من الخريطة')));
        return;
      }
      if (_complaintImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إضافة صورة واحدة على الأقل للشكوى')));
        return;
      }

      context.read<ComplaintBloc>().add(
        SubmitComplaintEvent(
          title: _titleController.text,
          description: _descriptionController.text,
          area: _selectedRegion!.name,
          latitude: _selectedLocation!.latitude,
          longitude: _selectedLocation!.longitude,
          complaintCategoryId: _selectedCategory!.categoryId,
          complaintImages: _complaintImages,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BlocConsumer<ComplaintBloc, ComplaintState>(
          listener: (context, state) {
            if (state is ComplaintErrorState) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("حدث خطأ"),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "حسناً",
                        style: TextStyle(color: Color(0xFF0172B2)),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ComplaintSubmittedSuccessfully) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => AlertDialog(
                  title: const Text("تم الإرسال بنجاح", style: TextStyle()),
                  content: const Text("شكراً لك، سيتم مراجعة الشكوى من قبل الجهات المختصة."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => MainNavigationPage()),
                        );
                      },
                      child: const Text(
                        "تم",
                        style: TextStyle(color: Color(0xFF0172B2)),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                        color: AppColors.RichBerry,
                      ),
                    ),
                    Expanded(child: Container(color: Colors.white)),
                  ],
                ),

                // App Bar
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => MainNavigationPage()),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'تقديم شكوى جديدة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // -----------Form-----------
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 100,
                    left: 16,
                    right: 16,
                    bottom: 32,
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'شاركنا شكواك لتوصيل صوتك للمسؤولين',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:Color(0xFF55304C),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'املأ النموذج التالي لتقديم شكواك',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Divider(
                              height: 24,
                              thickness: 1,
                              color: Colors.grey.shade300,
                            ),
                            _buildFormField(
                              controller: _titleController,
                              label: 'عنوان الشكوى',
                              icon: Icons.title,
                              validator: (value) =>
                              value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
                            ),
                            const SizedBox(height: 16),
                            // Category Dropdown
                            BlocBuilder<ComplaintBloc, ComplaintState>(
                              buildWhen: (previous, current) =>
                              current is CategoriesLoaded ||
                                  current is LoadingCategories,
                              builder: (context, state) {
                                if (state is CategoriesLoaded) {
                                  return _buildCategoryDropdown(state.categories);
                                }
                                return _buildLoadingDropdown('جاري تحميل التصنيفات...');
                              },
                            ).animate().fade(duration: 350.ms).slideY(begin: 0.2, curve: Curves.easeOut),
                            const SizedBox(height: 16),
                            // Region Dropdown
                            BlocBuilder<ComplaintBloc, ComplaintState>(
                              buildWhen: (previous, current) =>
                              current is RegionsLoaded ||
                                  current is LoadingRegions,
                              builder: (context, state) {
                                if (state is RegionsLoaded) {
                                  return _buildRegionDropdown(state.regions);
                                }
                                return _buildLoadingDropdown('جاري تحميل المناطق...');
                              },
                            ).animate().fade(duration: 350.ms).slideY(begin: 0.2, curve: Curves.easeOut),
                            const SizedBox(height: 16),
                            // Location Picker
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'يجب اختيار الموقع من الخريطة',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF848484),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _selectedLocation == null
                                            ? 'لم يتم تحديد الموقع على الخريطة'
                                            : 'تم تحديد الموقع بنجاح',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.normal,
                                          color: _selectedLocation == null ? const Color(0xFF848484) : Colors.green.shade700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.RichBerry,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: _navigateAndPickLocation,
                                      child: const Text(
                                        'اختر من الخريطة',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildImageSection(),
                            const SizedBox(height: 16),
                            _buildFormField(
                              controller: _descriptionController,
                              label: 'وصف الشكوى',
                              icon: Icons.description,
                              maxLines: 3,
                              validator: (value) =>
                              value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
                            ),
                            const SizedBox(height: 24),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.RichBerry,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed:
                                state is SubmittingComplaint
                                    ? null
                                    : _submitComplaint,
                                child: state is SubmittingComplaint
                                    ? const LoadingWidget()
                                    : const Text(
                                  'تقديم الشكوى',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: Color(0xFF848484),
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF55304C)
        ),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
  Widget _buildCategoryDropdown(List<ComplaintCategory> categories) {
    return DropdownButtonFormField<ComplaintCategory>(
      decoration: const InputDecoration(
        labelText: 'تصنيف الشكوى',
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: Color(0xFF848484),
        ),
        prefixIcon: Icon(Icons.category, color: Color(0xFF55304C)),
        border: OutlineInputBorder(),
      ),
      items: categories.map((category) {
        return DropdownMenuItem<ComplaintCategory>(
          value: category,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      validator: (value) => value == null ? 'الرجاء اختيار التصنيف' : null,
      value: _selectedCategory,
    );
  }
  Widget _buildRegionDropdown(List<RegionEntity> regions) {
    return DropdownButtonFormField<RegionEntity>(
      decoration: const InputDecoration(
        labelText: 'المنطقة',
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: Color(0xFF848484),
        ),
        prefixIcon: Icon(Icons.map_outlined, color: Color(0xFF55304C)),
        border: OutlineInputBorder(),
      ),
      items: regions.map((region) {
        return DropdownMenuItem<RegionEntity>(
          value: region,
          child: Text(region.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedRegion = value;
        });
      },
      validator: (value) => value == null ? 'الرجاء اختيار المنطقة' : null,
      value: _selectedRegion,
    );
  }
  Widget _buildLoadingDropdown(String label) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: Color(0xFF848484),
        ),
        prefixIcon: const Icon(Icons.hourglass_top, color: Color(0xFF55304C)
        ),
        border: const OutlineInputBorder(),
        suffixIcon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF55304C)
          ),
        ),
      ),
    );
  }
  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickImages,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: _complaintImages.isNotEmpty
                ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _complaintImages.map((imageFile) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            imageFile,
                            height: 92,
                            width: 92,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(_complaintImages.indexOf(imageFile)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
                : const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 28,
                    color: Color(0xFF55304C),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'اضغط لإضافة صورة أو أكثر',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF848484),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}