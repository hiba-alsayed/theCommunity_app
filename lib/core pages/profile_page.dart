import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:graduation_project/features/profile/presentation/pages/profile_details_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetMyProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => GetIt.instance<ProfileBloc>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(context),
            // You can add more content below this section for your Home Page
            Expanded(
              child: Center(
                child: Text(
                  'Welcome to Civil Society Campaign Management!',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePageDetails()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).primaryColor,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              final profile = state.profile;
              return Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: profile.imageUrl.isEmpty ? Colors.grey.shade300 : Colors.white.withOpacity(0.2),
                    child: profile.imageUrl.isEmpty
                        ? Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.grey.shade600,
                    )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          profile.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                ],
              );
            } else if (state is ProfileLoading) {
              return Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const CircularProgressIndicator(color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 120, height: 18, color: Colors.white.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      Container(width: 180, height: 14, color: Colors.white.withOpacity(0.3)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                ],
              );
            } else if (state is ProfileError) {
              return Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red.shade700,
                    child: const Icon(Icons.error_outline, color: Colors.white, size: 35),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Error loading profile: ${state.message}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                ],
              );
            } else {
              // ProfileInitial or other unexpected states
              return Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 35, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Tap to view profile',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}