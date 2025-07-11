import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core pages/location_picker_page.dart';
import '../../../notifications/presentation/firebase/api_notification_firebase.dart';
import '../bloc/auth_bloc.dart';
import 'confirm_page.dart';
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
  final _formKey = GlobalKey<FormState>();

  // Controllers for all text fields
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

  Future<void> _submitSignUp() async {
    final String? fcmToken = await firebaseApi.getFCMToken();
    if (fcmToken == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get notification token. Please check your connection and try again.')),
        );
      }
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('الرجاء اختيار الموقع من الخريطة')),
        );
        return;
      }
      // Dispatch PerformSignUp event to AuthBloc
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
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
                builder: (_) =>
                    // MainNavigationPage()
                    ConfirmationPage(email: state.user.email),
              ),
            );
          } else if (state is SignUpFailure) {
            // Show error message on failure
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('معلومات تسجيل الدخول'),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'الرجاء إدخال البريد الإلكتروني';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                            return 'صيغة البريد الإلكتروني غير صحيحة';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'الرجاء إدخال كلمة المرور';
                          if (value.length < 6)
                            return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordConfirmationController,
                        decoration: const InputDecoration(
                          labelText: 'تأكيد كلمة المرور',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'الرجاء تأكيد كلمة المرور';
                          if (value != _passwordController.text)
                            return 'كلمات المرور غير متطابقة';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      _buildSectionTitle('المعلومات الشخصية'),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'الاسم الكامل',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'الرجاء إدخال الاسم الكامل';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ageController,
                        decoration: const InputDecoration(
                          labelText: 'العمر',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'الرجاء إدخال العمر';
                          if (int.tryParse(value) == null ||
                              int.parse(value) < 18)
                            return 'يجب أن يكون العمر 18 عامًا على الأقل';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'الجنس',
                          prefixIcon: Icon(Icons.wc),
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedGender,
                        items:
                            _genders.map((String gender) {
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
                          if (value == null || value.isEmpty)
                            return 'الرجاء اختيار الجنس';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'الرجاء إدخال رقم الهاتف';
                          if (!RegExp(r'^\+?[0-9]{10,}$').hasMatch(value))
                            return 'صيغة رقم الهاتف غير صحيحة';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _bioController,
                        decoration: const InputDecoration(
                          labelText: 'نبذة عنك',
                          prefixIcon: Icon(Icons.info_outline),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _areaController,
                        decoration: const InputDecoration(
                          labelText: 'المنطقة ',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              _selectedLocation == null) {
                            return 'الرجاء اختيار موقعك من الخريطة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width:
                            double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationPickerPage(),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _selectedLocation = result['location'];
                                print('$_selectedLocation');
                              });
                            }
                          },
                          icon: const Icon(Icons.map),
                          label: const Text('اختيار الموقع من الخريطة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors
                                    .blueGrey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 32),

                      _buildSectionTitle('الصورة الشخصية'),
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                _imagePath != null
                                    ? FileImage(File(_imagePath!))
                                    : null,
                            child:
                                _imagePath == null
                                    ? Icon(
                                      Icons.camera_alt,
                                      size: 40,
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
                            child: const Text('إزالة الصورة'),
                          ),
                        ),
                      const SizedBox(height: 32),

                      Center(
                        child: ElevatedButton.icon(
                          onPressed:
                              // (state is SignUpLoading) ? null :
                              _submitSignUp,
                          icon: const Icon(Icons.person_add),
                          label: Text(
                            (state is SignUpLoading)
                                ? 'جارٍ التسجيل...'
                                : 'إنشاء حساب',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
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

  // Helper for section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[700],
        ),
      ),
    );
  }

  // Helper for multi-select chips
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children:
              allOptions.map((option) {
                final isSelected = selectedOptions.contains(option);
                return FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedOptions.add(option);
                      } else {
                        selectedOptions.remove(option);
                      }
                      onSelectionChanged(selectedOptions); // Call the callback
                    });
                  },
                  selectedColor: Colors.blueAccent.withOpacity(0.3),
                  checkmarkColor: Colors.blueAccent,
                );
              }).toList(),
        ),
      ],
    );
  }
}
