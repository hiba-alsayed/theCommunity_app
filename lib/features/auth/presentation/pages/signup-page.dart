import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/features/auth/presentation/pages/login_page.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core pages/location_picker_page.dart';
import '../../../notifications/presentation/firebase/api_notification_firebase.dart';
import '../bloc/auth_bloc.dart';
import 'confirm_page.dart';
import '../widgets/animated_widget.dart';
const Map<String, int> skillNameToId = {
  'تمريض': 1,
  'طبخ': 2,
  'جمع تبرعات': 3,
  'تصوير': 4,
  'مهنية': 5,
};
const Map<String, int> volunteerFieldNameId = {
  'ترميم بيوت': 1,
  'توزيع مساعدات': 2,
  'تنظيم فعالية': 3,
  'إغاثة الكوارث': 4,
  'مساعدات الطريق': 5,
  'تنظيف البيئة': 6,
};
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}
class _SignUpPageState extends State<SignUpPage> {
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeyPersonal = GlobalKey<FormState>();
  final _formKeySkills = GlobalKey<FormState>();

  final PageController _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
  TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  String? _selectedGender;
  List<String> _selectedSkills = [];
  List<String> _selectedVolunteerFields = [];
  String? _imagePath;
  LatLng? _selectedLocation;
  final firebaseApi = FirebaseApi();

  final List<String> _genders = ['male', 'female'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _areaController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _goToNextPage() {
    bool isValid = false;
    if (_currentPage == 0) {
      isValid = _formKeyLogin.currentState?.validate() ?? false;
    } else if (_currentPage == 1) {
      isValid = _formKeyPersonal.currentState?.validate() ?? false;
      if (isValid && _selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء اختيار الموقع من الخريطة')),
        );
        isValid = false;
      }
    } else if (_currentPage == 2) {
      isValid = _formKeySkills.currentState?.validate() ?? false;
    }

    if (isValid && _currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  Future<void> _submitSignUp() async {
    if (!(_formKeySkills.currentState?.validate() ?? false)) {
      return;
    }
    final String? fcmToken = await firebaseApi.getFCMToken();
    if (fcmToken == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Could not get notification token. Please check your connection and try again.')),
        );
      }
      return;
    }

    context.read<AuthBloc>().add(
      PerformSignUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmationController.text,
        name: _nameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()) ?? 0,
        phone: _phoneController.text.trim(),
        gender: _selectedGender ?? '',
        bio: _bioController.text.trim(),
        deviceToken: fcmToken,
        skills: _selectedSkills,
        volunteerFields: _selectedVolunteerFields,
        longitude: _selectedLocation!.longitude,
        latitude: _selectedLocation!.latitude,
        area: _areaController.text.trim(),
        image: _imagePath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم التسجيل بنجاح! تحقق من بريدك الإلكتروني.'),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ConfirmationPage(email: state.user.email),
              ),
            );
          } else if (state is SignUpFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFF0172B2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                top: 40.h,
                right: 20.w,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/athar_white.png',
                      width: 40.w,
                      height: 40.h,
                    ),
                  ],
                ),
              ),
              const AnimatedCircleBackground(),
              Positioned(
                top: 150.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "انضم إلينا الآن وكن جزءًا من العطاء!\n",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 250.h,
                left: 10.w,
                right: 10.w,
                bottom: 10.h,
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15.r,
                        spreadRadius: 5.r,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildLoginPageForm(keyboardHeight);
                            } else if (index == 1) {
                              return _buildPersonalInfoForm(keyboardHeight);
                            } else {
                              return _buildSkillsAndPhotoForm(state, keyboardHeight);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentPage > 0)
                            Expanded(
                              child: TextButton(
                                onPressed: _goToPreviousPage,
                                child: Text(
                                  'رجوع',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (_currentPage < 2)
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.white, Color(0xFF0172B2)],
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(double.infinity, 50.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                  ),
                                  onPressed: _goToNextPage,
                                  child: Text(
                                    'التالي',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (_currentPage == 2)
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.white, Color(0xFF0172B2)],
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(double.infinity, 50.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                  ),
                                  onPressed: (state is SignUpLoading)
                                      ? null
                                      : _submitSignUp,
                                  child: (state is SignUpLoading)
                                      ? SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child:
                                    const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : Text(
                                    'إنشاء حساب',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade400,
                              height: 1.h,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              'أو',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade400,
                              height: 1.h,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginPage()));
                          },
                          child: Text(
                            'لديك حساب بالفعل؟ تسجيل الدخول',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fade(duration: 800.ms)
                    .slideY(begin: 0.2, curve: Curves.easeOut),
              ),
              // Loading overlay
              if (state is SignUpLoading)
                const ModalBarrier(color: Colors.black45, dismissible: false),
              if (state is SignUpLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }

  // --- Form Section Widgets ---

  Widget _buildLoginPageForm(double keyboardHeight) {
    return Form(
      key: _formKeyLogin,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: keyboardHeight + 10.h), // Add extra fixed padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFormField(
              _emailController,
              'البريد الإلكتروني',
              Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال البريد الإلكتروني';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'صيغة البريد الإلكتروني غير صحيحة';
                }
                return null;
              },
            ),
            _buildTextFormField(
              _passwordController,
              'كلمة المرور',
              Icons.lock,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال كلمة المرور';
                }
                if (value.length < 6) {
                  return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                }
                return null;
              },
            ),
            _buildTextFormField(
              _passwordConfirmationController,
              'تأكيد كلمة المرور',
              Icons.lock,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء تأكيد كلمة المرور';
                }
                if (value != _passwordController.text) {
                  return 'كلمات المرور غير متطابقة';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoForm(double keyboardHeight) {
    return Form(
      key: _formKeyPersonal,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: keyboardHeight + 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('المعلومات الشخصية'),
            _buildTextFormField(
              _nameController,
              'الاسم الكامل',
              Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال الاسم الكامل';
                }
                return null;
              },
            ),
            _buildTextFormField(
              _ageController,
              'العمر',
              Icons.calendar_today,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال العمر';
                }
                if (int.tryParse(value) == null || int.parse(value) < 18) {
                  return 'يجب أن يكون العمر 18 عامًا على الأقل';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'الجنس',
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF848484),
                ),
                prefixIcon: const Icon(Icons.wc, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFF00B4D8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
              ),
              value: _selectedGender,
              items: _genders.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender == 'male' ? 'ذكر' : 'أنثى'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء اختيار الجنس';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            _buildTextFormField(
              _phoneController,
              'رقم الهاتف',
              Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال رقم الهاتف';
                }
                if (!RegExp(r'^\+?[0-9]{10,}$').hasMatch(value)) {
                  return 'صيغة رقم الهاتف غير صحيحة';
                }
                return null;
              },
            ),
            _buildTextFormField(
              _bioController,
              'نبذة عنك',
              Icons.info_outline,
              maxLines: 3,
            ),
            _buildTextFormField(
              _areaController,
              'المنطقة',
              Icons.location_on,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    _selectedLocation == null) {
                  return 'الرجاء اختيار موقعك من الخريطة';
                }
                return null;
              },
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationPickerPage(),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _selectedLocation = result['location'];
                      _areaController.text =
                          result['area'] ?? '';
                      print('$_selectedLocation');
                    });
                  }
                },
                icon: const Icon(Icons.map, color: Colors.white),
                label: Text(
                  _selectedLocation == null
                      ? 'اختيار الموقع من الخريطة'
                      : 'تم اختيار الموقع',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0172B2),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsAndPhotoForm(AuthState state, double keyboardHeight) {
    return Form(
      key: _formKeySkills,
      child: SingleChildScrollView(
        // MODIFIED: Add keyboardHeight as padding here
        padding: EdgeInsets.only(bottom: keyboardHeight + 10.h), // Add extra fixed padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('المهارات ومجالات التطوع'),
            _buildMultiSelectChip(
              'المهارات',
              skillNameToId.keys.toList(),
              _selectedSkills,
                  (selectedList) {
                setState(() {
                  _selectedSkills = selectedList;
                });
              },
            ),
            SizedBox(height: 16.h),
            _buildMultiSelectChip(
              'مجالات التطوع',
              volunteerFieldNameId.keys.toList(),
              _selectedVolunteerFields,
                  (selectedList) {
                setState(() {
                  _selectedVolunteerFields = selectedList;
                });
              },
            ),
            SizedBox(height: 32.h),
            _buildSectionTitle('الصورة الشخصية'),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60.r,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                  _imagePath != null ? FileImage(File(_imagePath!)) : null,
                  child: _imagePath == null
                      ? Icon(
                    Icons.camera_alt,
                    size: 40.sp,
                    color: Colors.grey[600],
                  )
                      : null,
                ),
              ),
            ),
            if (_imagePath != null)
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _imagePath = null;
                    });
                  },
                  child: Text(
                    'إزالة الصورة',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
  Widget _buildTextFormField(
      TextEditingController controller,
      String labelText,
      IconData icon, {
        TextInputType keyboardType = TextInputType.text,
        bool obscureText = false,
        int maxLines = 1,
        String? Function(String?)? validator,
      }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF848484),
            ),
            prefixIcon: Icon(icon, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF0172B2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
          validator: validator,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
  Widget _buildMultiSelectChip(
      String title,
      List<String> allOptions,
      List<String> selectedOptions,
      Function(List<String>) onSelectionChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.0.w,
          runSpacing: 8.0.h,
          children: allOptions.map((option) {
            final isSelected = selectedOptions.contains(option);
            return FilterChip(
              label: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 14.sp,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedOptions.add(option);
                  } else {
                    selectedOptions.remove(option);
                  }
                  onSelectionChanged(selectedOptions);
                });
              },
              selectedColor: const Color(0xFF0172B2),
              checkmarkColor: Colors.white,
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: BorderSide(
                  color:
                  isSelected ? const Color(0xFF0172B2) : Colors.grey.shade300,
                  width: 1.w,
                ),
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            );
          }).toList(),
        ),
      ],
    );
  }
}