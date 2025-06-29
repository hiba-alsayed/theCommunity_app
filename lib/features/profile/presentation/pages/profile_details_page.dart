import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/profile/domain/entity/profile_entity.dart';
import 'package:graduation_project/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';

// class ProfilePageDetails extends StatefulWidget {
//   const ProfilePageDetails({super.key});
//
//   @override
//   State<ProfilePageDetails> createState() => _ProfilePageDetailsState();
// }
//
// class _ProfilePageDetailsState extends State<ProfilePageDetails> {
//   late final ProfileBloc _bloc;
//
//   @override
//   void initState() {
//     super.initState();
//     _bloc = GetIt.instance<ProfileBloc>();
//     _bloc.add(GetMyProfileEvent());
//   }
//
//   Future<void> _onRefresh() async {
//     _bloc.add(GetMyProfileEvent());
//     await Future.delayed(const Duration(milliseconds: 500));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _bloc,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('My Profile'),
//           elevation: 0,
//           centerTitle: true,
//         ),
//         body: RefreshIndicator(
//           onRefresh: _onRefresh,
//           child: BlocConsumer<ProfileBloc, ProfileState>(
//             listener: (context, state) {
//               if (state is ProfileError) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(state.message)),
//                 );
//               }
//             },
//             builder: (context, state) {
//               if (state is ProfileLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is ProfileLoaded) {
//                 return _buildProfileContent(context, state.profile);
//               } else if (state is ProfileError) {
//                 return Center(
//                   child: SingleChildScrollView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.error_outline, color: Colors.red, size: 60),
//                         const SizedBox(height: 16),
//                         Text(
//                           state.message,
//                           textAlign: TextAlign.center,
//                           style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red),
//                         ),
//                         const SizedBox(height: 24),
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             _bloc.add(GetMyProfileEvent());
//                           },
//                           icon: const Icon(Icons.refresh),
//                           label: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }
//               return const Center(child: CircularProgressIndicator());
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileContent(BuildContext context, ProfileEntity profile) {
//     return SingleChildScrollView(
//       physics: const AlwaysScrollableScrollPhysics(),
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _buildProfileHeader(profile),
//           const SizedBox(height: 24),
//           _buildSectionCard(
//             context,
//             title: 'Contact Information',
//             children: [
//               _buildInfoRow(Icons.email, profile.email),
//               _buildInfoRow(Icons.phone, profile.phone),
//               _buildInfoRow(Icons.location_on, profile.location.name),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildSectionCard(
//             context,
//             title: 'About Me',
//             children: [
//               _buildInfoRow(Icons.cake, 'Age: ${profile.age}'),
//               _buildInfoRow(Icons.person, 'Gender: ${profile.gender}'),
//               const SizedBox(height: 12),
//               Text(
//                 profile.bio,
//                 style: Theme.of(context).textTheme.bodyLarge,
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildSectionCard(
//             context,
//             title: 'Skills',
//             children: [
//               if (profile.skills.isNotEmpty)
//                 _buildChips(profile.skills)
//               else
//                 const Text('No skills listed yet.'),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildSectionCard(
//             context,
//             title: 'Fields of Interest',
//             children: [
//               if (profile.fields.isNotEmpty)
//                 _buildChips(profile.fields)
//               else
//                 const Text('No fields of interest listed yet.'),
//             ],
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'Profile created: ${profile.createdAt.toLocal().toIso8601String().split('T')[0]}',
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileHeader(ProfileEntity profile) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 60,
//           backgroundColor: profile.imageUrl.isEmpty ? Colors.grey.shade300 : Theme.of(context).primaryColor.withOpacity(0.1),
//           child: profile.imageUrl.isEmpty
//               ? Icon(
//             Icons.person,
//             size: 70,
//             color: Colors.grey.shade600,
//           )
//               : null,
//         ),
//         const SizedBox(height: 16),
//         Text(
//           profile.name,
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//         Text(
//           profile.email,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSectionCard(BuildContext context,
//       {required String title, required List<Widget> children}) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: EdgeInsets.zero,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).colorScheme.secondary,
//               ),
//             ),
//             const Divider(height: 24, thickness: 1),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: Colors.grey[700]),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               text,
//               style: Theme.of(context).textTheme.bodyLarge,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChips(List<String> items) {
//     return Wrap(
//       spacing: 8.0,
//       runSpacing: 8.0,
//       children: items
//           .map((item) => Chip(
//         label: Text(item),
//         backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//         labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
//           color: Theme.of(context).colorScheme.primary,
//           fontWeight: FontWeight.bold,
//         ),
//         side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
//       ))
//           .toList(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/profile/domain/entity/profile_entity.dart';
import 'package:graduation_project/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';

class ProfilePageDetails extends StatefulWidget {
  const ProfilePageDetails({super.key});

  @override
  State<ProfilePageDetails> createState() => _ProfilePageDetailsState();
}

class _ProfilePageDetailsState extends State<ProfilePageDetails> {
  late final ProfileBloc _bloc;
  bool _isEditing = false;

  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _fieldsController = TextEditingController();

  String? _selectedGender;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.instance<ProfileBloc>();
    _bloc.add(GetMyProfileEvent());
  }

  @override
  void dispose() {
    _bioController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _areaController.dispose();
    _skillsController.dispose();
    _fieldsController.dispose();
    super.dispose();
  }

  // --- NEW HELPER FUNCTION ---
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  // -------------------------

  void _populateControllers(ProfileEntity profile) {
    _bioController.text = profile.bio;
    _phoneController.text = profile.phone;
    _ageController.text = profile.age.toString();
    // --- UPDATED LINE HERE ---
    _selectedGender = profile.gender.isEmpty ? null : _capitalizeFirstLetter(profile.gender);
    // -------------------------
    _areaController.text = profile.location.name;
    _skillsController.text = profile.skills.join(', ');
    _fieldsController.text = profile.fields.join(', ');
  }

  Future<void> _onRefresh() async {
    _bloc.add(GetMyProfileEvent());
    await Future.delayed(const Duration(milliseconds: 500));
    if (_isEditing) {
      setState(() {
        _isEditing = false;
      });
    }
  }

  void _toggleEditMode(ProfileEntity? profile) {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing && profile != null) {
        _populateControllers(profile);
      }
    });
  }

  void _submitProfileUpdate(ProfileEntity currentProfile) async {
    String deviceToken = "some_device_token_placeholder"; // TODO: Implement actual device token retrieval

    if (_formKey.currentState!.validate()) {
      _bloc.add(
        UpdateClientProfileEvent(
          age: int.tryParse(_ageController.text) ?? 0,
          phone: _phoneController.text,
          gender: _selectedGender ?? '',
          bio: _bioController.text,
          deviceToken: deviceToken,
          volunteerFields: _fieldsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
          longitude: currentProfile.location.longitude,
          latitude: currentProfile.location.latitude,
          area: _areaController.text,
          skills: _skillsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          elevation: 0,
          centerTitle: true,
          actions: [
            BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (previous, current) =>
              current is ProfileLoaded ||
                  current is UpdateProfileLoading ||
                  current is UpdateProfileSuccess ||
                  current is UpdateProfileError,
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return IconButton(
                    icon: Icon(_isEditing ? Icons.save : Icons.edit),
                    onPressed: () {
                      if (_isEditing) {
                        _submitProfileUpdate(state.profile);
                      } else {
                        _toggleEditMode(state.profile);
                      }
                    },
                  );
                } else if (state is UpdateProfileLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is UpdateProfileSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                setState(() {
                  _isEditing = false;
                });
                _bloc.add(GetMyProfileEvent());
              } else if (state is UpdateProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading || state is UpdateProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                if (!_isEditing) {
                  _populateControllers(state.profile);
                }
                return _buildProfileContent(context, state.profile);
              } else if (state is ProfileError) {
                return Center(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            _bloc.add(GetMyProfileEvent());
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileEntity profile) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileHeader(profile),
            const SizedBox(height: 24),
            _buildSectionCard(
              context,
              title: 'Contact Information',
              children: [
                _buildInfoRow(Icons.email, profile.email, isEditable: false),
                _isEditing
                    ? _buildEditableTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number cannot be empty.';
                    }
                    return null;
                  },
                )
                    : _buildInfoRow(Icons.phone, profile.phone),
                _isEditing
                    ? _buildEditableTextField(
                  controller: _areaController,
                  label: 'Area',
                  icon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Area cannot be empty.';
                    }
                    return null;
                  },
                )
                    : _buildInfoRow(Icons.location_on, profile.location.name),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              context,
              title: 'About Me',
              children: [
                _isEditing
                    ? _buildEditableTextField(
                  controller: _ageController,
                  label: 'Age',
                  icon: Icons.cake,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Age cannot be empty.';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Please enter a valid age.';
                    }
                    return null;
                  },
                )
                    : _buildInfoRow(Icons.cake, 'Age: ${profile.age}'),
                _isEditing
                    ? _buildGenderDropdown()
                    : _buildInfoRow(Icons.person, 'Gender: ${profile.gender}'),
                const SizedBox(height: 12),
                _isEditing
                    ? _buildEditableTextField(
                  controller: _bioController,
                  label: 'Bio',
                  icon: Icons.text_fields,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bio cannot be empty.';
                    }
                    return null;
                  },
                )
                    : Text(
                  profile.bio,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              context,
              title: 'Skills',
              children: [
                _isEditing
                    ? _buildEditableTextField(
                  controller: _skillsController,
                  label: 'Skills (comma-separated)',
                  icon: Icons.lightbulb_outline,
                  hintText: 'e.g., Flutter, Dart, UI/UX',
                )
                    : (profile.skills.isNotEmpty
                    ? _buildChips(profile.skills)
                    : const Text('No skills listed yet.')),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              context,
              title: 'Fields of Interest',
              children: [
                _isEditing
                    ? _buildEditableTextField(
                  controller: _fieldsController,
                  label: 'Fields of Interest (comma-separated)',
                  icon: Icons.category,
                  hintText: 'e.g., Environment, Education, Health',
                )
                    : (profile.fields.isNotEmpty
                    ? _buildChips(profile.fields)
                    : const Text('No fields of interest listed yet.')),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Profile created: ${profile.createdAt.toLocal().toIso8601String().split('T')[0]}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender == '' ? null : _selectedGender,
        decoration: InputDecoration(
          labelText: 'Gender',
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        items: const [
          DropdownMenuItem(value: 'male', child: Text('Myale')),
          DropdownMenuItem(value: 'female', child: Text('female')),
        ],
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select your gender.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildProfileHeader(ProfileEntity profile) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: profile.imageUrl.isEmpty ? Colors.grey.shade300 : Theme.of(context).primaryColor.withOpacity(0.1),
          child: profile.imageUrl.isEmpty
              ? Icon(
            Icons.person,
            size: 70,
            color: Colors.grey.shade600,
          )
              : (profile.imageUrl.startsWith('http')
              ? ClipOval(
            child: Image.network(
              profile.imageUrl,
              fit: BoxFit.cover,
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.person,
                size: 70,
                color: Colors.grey.shade600,
              ),
            ),
          )
              : Icon(Icons.person, size: 70, color: Colors.grey.shade600)),
        ),
        const SizedBox(height: 16),
        Text(
          profile.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          profile.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSectionCard(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const Divider(height: 24, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChips(List<String> items) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: items
          .map((item) => Chip(
        label: Text(item),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
      ))
          .toList(),
    );
  }
}
