import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/profile/domain/entity/profile_entity.dart';
import 'package:graduation_project/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/core/app_color.dart';

class GetProfileByUserIdPage extends StatefulWidget {
  final int userId;
  final String userName;

  const GetProfileByUserIdPage({
    super.key,
    required this.userId,
    this.userName = 'User Profile',
  });

  @override
  State<GetProfileByUserIdPage> createState() => _GetProfileByUserIdPageState();
}

class _GetProfileByUserIdPageState extends State<GetProfileByUserIdPage> {
  late final ProfileBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.instance<ProfileBloc>();
    _bloc.add(GetProfileByUserIdEvent(userId: widget.userId));
  }

  Future<void> _onRefresh() async {
    _bloc.add(GetProfileByUserIdEvent(userId: widget.userId));
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.userName),
          elevation: 0,
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileError) {
                // Show a SnackBar for errors
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                return _buildProfileContent(context, state.profile);
              } else if (state is ProfileError) {
                return Center(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 60),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.red),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            _bloc.add(GetProfileByUserIdEvent(
                                userId: widget.userId));
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة المحاولة'),
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
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileHeader(profile),
          const SizedBox(height: 24),
          _buildSectionCard(
            context,
            title: 'معلومات الاتصال',
            children: [
              _buildInfoRow(Icons.email, profile.email),
              _buildInfoRow(Icons.phone, profile.phone),
              _buildInfoRow(Icons.location_on, profile.location.name),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            title: 'عني',
            children: [
              _buildInfoRow(Icons.cake, 'العمر: ${profile.age}'),
              _buildInfoRow(Icons.person, 'الجنس: ${profile.gender}'),
              const SizedBox(height: 12),
              Text(
                profile.bio,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            title: 'المهارات',
            children: [
              if (profile.skills.isNotEmpty)
                _buildChips(profile.skills)
              else
                const Text('لاتوجد مهارات حاليا.'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            title: 'مجالات الاهتمام',
            children: [
              if (profile.fields.isNotEmpty)
                _buildChips(profile.fields)
              else
                const Text('لايوجد مجالات اهتمام بعد.'),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Profile created: ${profile.createdAt.toLocal().toIso8601String().split('T')[0]}',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ProfileEntity profile) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: profile.imageUrl.isEmpty
              ? Colors.grey.shade300
              : Theme.of(context).primaryColor.withOpacity(0.1),
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
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey[600]),
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
                color: AppColors.OliveGrove,
              ),
            ),
            const Divider(
              height: 24,
              thickness: 1,
              color: Colors.black12,
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
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
        backgroundColor:
        Theme.of(context).colorScheme.primary.withOpacity(0.1),
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.OliveMid,
          fontWeight: FontWeight.bold,
        ),
        side: BorderSide(
            color: Theme.of(context).colorScheme.primary),
      ))
          .toList(),
    );
  }
}