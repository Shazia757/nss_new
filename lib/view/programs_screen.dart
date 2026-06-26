import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nss_new/common_pages/navbar.dart';
import 'package:nss_new/view/home_screen.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  int _selectedTab = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _upcomingList = [
    {
      'title': 'Blood Donation Camp 2026',
      'date': 'June 28, 2026',
      'duration': '5 hours',
      'description':
          'A collaborative blood donation drive with the local Government Hospital. Join us in saving lives and raising awareness about healthcare.',
    },
    {
      'title': 'Adopted Village Clean Drive',
      'date': 'July 02, 2026',
      'duration': '4 hours',
      'description':
          'Help clean public spaces, set up proper waste disposal systems, and educate the villagers on community hygiene and sanitation practices.',
    },
    {
      'title': 'NSS Special Tree Plantation',
      'date': 'July 10, 2026',
      'duration': '3 hours',
      'description':
          'Help plant over 200 native saplings in the Adopted Village to combat local deforestation and promote environmental restoration.',
    },
  ];

  final List<Map<String, String>> _pastList = [
    {
      'title': 'Anti-Drug Awareness Rally',
      'date': 'May 15, 2026',
      'duration': '2 hours',
      'description':
          'Successfully conducted an awareness rally through the local town center to educate youth against drug and substance abuse.',
    },
    {
      'title': 'Summer Camp for Kids',
      'date': 'April 20 - 25, 2026',
      'duration': '5 days',
      'description':
          'Organized an interactive summer camp providing basic computer literacy and arts/crafts training for under-privileged students.',
    },
    {
      'title': 'Palliative Care Training',
      'date': 'March 10, 2026',
      'duration': '6 hours',
      'description':
          'Basic orientation and palliative care volunteer training session conducted in partnership with Farook College Palliative unit.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Filter lists based on search query
    final filteredUpcoming = _upcomingList.where((p) {
      final titleMatch =
          p['title']?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
          false;
      final descMatch =
          p['description']?.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ??
          false;
      return titleMatch || descMatch;
    }).toList();

    final filteredPast = _pastList.where((p) {
      final titleMatch =
          p['title']?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
          false;
      final descMatch =
          p['description']?.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ??
          false;
      return titleMatch || descMatch;
    }).toList();

    final currentList = _selectedTab == 0 ? filteredUpcoming : filteredPast;

    return SafeArea(
      child: Scaffold(
        backgroundColor: cs.surface,
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Navigation & Search Bar
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 16.0,
                top: 12.0,
                bottom: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: cs.primary),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: cs.outline.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search programs...',
                          hintStyle: tt.bodyMedium?.copyWith(
                            color: cs.onSurface.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: cs.onSurface.withOpacity(0.6),
                            size: 20,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: cs.onSurface.withOpacity(0.6),
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Title and Subtitle Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Programs',
                    style: tt.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discover and participate in social service activities',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tab Bar Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildTabButton(
                    context,
                    'Upcoming programs',
                    isSelected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                  _buildTabButton(
                    context,
                    'Past Activities',
                    isSelected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Program Cards List
            Expanded(
              child: currentList.isEmpty
                  ? Center(
                      child: Text(
                        'No programs found',
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurface.withOpacity(0.5),
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 900
                            ? 3
                            : constraints.maxWidth > 600
                            ? 2
                            : 1;
                        return MasonryGridView.count(
                          crossAxisCount: crossAxisCount,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          itemCount: currentList.length,
                          itemBuilder: (context, index) {
                            final program = currentList[index];

                            return _buildProgramCard(
                              context: context,
                              title: program['title'] ?? '',
                              date: program['date'] ?? '',
                              duration: program['duration'] ?? '',
                              description: program['description'] ?? '',
                              isPast: _selectedTab == 1,
                              cs: cs,
                              tt: tt,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                label,
                style: tt.titleSmall?.copyWith(
                  color: isSelected
                      ? cs.primary
                      : cs.onSurface.withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 2,
              color: isSelected ? cs.primary : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramCard({
    required BuildContext context,
    required String title,
    required String date,
    required String duration,
    required String description,
    required bool isPast,
    required ColorScheme cs,
    required TextTheme tt,
  }) {
    final Color cardBg = isPast ? cs.outline.withOpacity(0.08) : cs.onPrimary;
    final Color borderColor = isPast
        ? cs.outline.withOpacity(0.3)
        : cs.outline.withOpacity(0.6);
    final Color titleColor = isPast
        ? cs.onSurface.withOpacity(0.5)
        : cs.onSurface;
    final Color textColor = isPast
        ? cs.onSurface.withOpacity(0.4)
        : cs.onSurface.withOpacity(0.7);
    final Color iconColor = isPast ? cs.onSurface.withOpacity(0.4) : cs.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: isPast
            ? []
            : [
                BoxShadow(
                  color: cs.shadow.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(date, style: tt.bodySmall?.copyWith(color: textColor)),
              const SizedBox(width: 16),
              Icon(Icons.hourglass_empty, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(duration, style: tt.bodySmall?.copyWith(color: textColor)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: tt.bodyMedium?.copyWith(color: textColor, height: 1.4),
          ),
          if (!isPast) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: FilledButton(
                onPressed: () {
                  // Handle enroll action
                },
                style: FilledButton.styleFrom(
                  backgroundColor: cs.secondary,
                  foregroundColor: cs.onSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Enroll Now',
                  style: tt.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSecondary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
