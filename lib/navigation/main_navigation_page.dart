import 'package:flutter/material.dart';
import '../core pages/home_page.dart';
import '../core pages/profile_page.dart';
import '../features/campaigns/presentation/pages/get_all_campaigns_page.dart';
import '../features/campaigns/presentation/pages/recommended_page.dart';
import '../features/complaints/presentation/pages/get_all_complaints.dart';
import '../features/profile/presentation/pages/profile_details_page.dart';
import '../features/suggestions/presentation/pages/suggestions_page.dart';
import 'bottom_bar.dart';


class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({Key? key}) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CampaignsPage(),
    SuggestionsPage(),
    ComplaintsPage(),
    ProfilePageDetails(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
