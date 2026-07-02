import 'package:flutter/material.dart';
import 'package:nss_new/common_pages/navbar.dart';
import 'package:nss_new/view/home_screen.dart';

class AttendanceScreen extends StatefulWidget {
  final Map<String, dynamic>? volunteer;
  const AttendanceScreen({super.key, this.volunteer});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> programsList = [
    {
      'title': 'Blood Donation Camp 2026',
      'location': 'Farook College Auditorium',
      'date': 'June 28, 2026',
    },
    {
      'title': 'Adopted Village Clean Drive',
      'location': 'Kodiyathur Adopted Village',
      'date': 'July 02, 2026',
    },
    {
      'title': 'NSS Special Tree Plantation',
      'location': 'NSS Adopted Village',
      'date': 'July 10, 2026',
    },
    {
      'title': 'Beach Cleanup Mission',
      'location': 'Kozhikode Beach',
      'date': 'July 18, 2026',
    },
    {
      'title': 'Health Awareness Campaign',
      'location': 'Community Health Centre, Feroke',
      'date': 'July 24, 2026',
    },
    {
      'title': 'Literacy Support Program',
      'location': 'Government LP School, Ramanattukara',
      'date': 'August 01, 2026',
    },
    {
      'title': 'Women Empowerment Workshop',
      'location': 'Farook College Seminar Hall',
      'date': 'August 08, 2026',
    },
    {
      'title': 'Independence Day Service Activity',
      'location': 'Farook College Campus',
      'date': 'August 15, 2026',
    },
    {
      'title': 'Road Safety Awareness Rally',
      'location': 'Feroke Town',
      'date': 'August 22, 2026',
    },
    {
      'title': 'Campus Green Initiative',
      'location': 'Farook College Grounds',
      'date': 'September 05, 2026',
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

    final List<Map<String, dynamic>> attendedPrograms = widget.volunteer != null
        ? List<Map<String, dynamic>>.from(
            widget.volunteer!['attendedPrograms'] ?? [],
          )
        : [];

    final filteredProgram = widget.volunteer != null
        ? attendedPrograms.where((p) {
            final titleMatch =
                p['title']?.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ??
                false;
            return titleMatch;
          }).toList()
        : programsList.where((p) {
            final titleMatch =
                p['title']?.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ??
                false;
            return titleMatch;
          }).toList();

    return Scaffold(
      backgroundColor: cs.surface,
      bottomNavigationBar: widget.volunteer != null
          ? null
          : const CustomBottomNavBar(currentIndex: 2),
      body: SafeArea(
        child: Column(
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
                          hintText: 'Search records...',
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
                    widget.volunteer != null
                        ? widget.volunteer!['name'] ?? 'Attendance'
                        : 'Attendance',
                    style: tt.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.volunteer != null
                        ? 'Admission No: ${widget.volunteer!['admissionNo']} • ${widget.volunteer!['program']}'
                        : 'Review your participation in NSS activities and service programs.',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Outlined Stat Cards Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard(
                          context,
                          'TOTAL PROGRAMS',
                          widget.volunteer != null
                              ? '${(widget.volunteer!['attendedPrograms'] as List).length} activities'
                              : '14 activities',
                          cs,
                          tt,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          context,
                          widget.volunteer != null
                              ? 'TOTAL HOURS'
                              : 'CURRENT MONTH',
                          widget.volunteer != null
                              ? '${(widget.volunteer!['attendedPrograms'] as List).fold<int>(0, (sum, p) => sum + (int.tryParse(p['hours']?.toString() ?? '0') ?? 0))} hours'
                              : '${programsList.length} attended',
                          cs,
                          tt,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          context,
                          widget.volunteer != null
                              ? 'AVG. HOURS'
                              : 'RELIABILITY',
                          widget.volunteer != null
                              ? (() {
                                  final list =
                                      widget.volunteer!['attendedPrograms']
                                          as List;
                                  if (list.isEmpty) return '0.0 hrs/event';
                                  final total = list.fold<int>(
                                    0,
                                    (sum, p) =>
                                        sum +
                                        (int.tryParse(
                                              p['hours']?.toString() ?? '0',
                                            ) ??
                                            0),
                                  );
                                  return '${(total / list.length).toStringAsFixed(1)} hrs/event';
                                })()
                              : '92% Participation',
                          cs,
                          tt,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section Heading: Program History
                    Text(
                      'Program History',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // History Cards List
                    if (filteredProgram.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            'No programs found',
                            style: tt.bodyMedium?.copyWith(
                              color: cs.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      )
                    else
                      ...filteredProgram.map(
                        (program) => _buildHistoryCard(
                          context: context,
                          title: program['title'] ?? '',
                          location: widget.volunteer != null
                              ? (program['remarks']?.toString().isNotEmpty ==
                                        true
                                    ? program['remarks']!.toString()
                                    : 'Log Recorded')
                              : (program['location'] ?? ''),
                          date: program['date'] ?? '',
                          hours: widget.volunteer != null
                              ? program['hours']?.toString()
                              : null,
                          cs: cs,
                          tt: tt,
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Participation Warning/Note Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.secondary.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          left: BorderSide(color: cs.secondary, width: 4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: cs.secondary,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Note on Participation',
                                style: tt.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Regular attendance is vital for the NSS Award and Certificate eligibility. Please ensure your presence is marked by the Unit Secretary during every program. If you find any discrepancies, contact your Program Officer.',
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurface.withOpacity(0.8),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    ColorScheme cs,
    TextTheme tt,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.labelSmall?.copyWith(
                color: cs.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.bold,
                fontSize: 8.5,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.bodyMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required BuildContext context,
    required String title,
    required String location,
    required String date,
    String? hours,
    required ColorScheme cs,
    required TextTheme tt,
  }) {
    final parts = date.split(' ');
    String month = 'NSS';
    String day = '--';
    if (parts.isNotEmpty) {
      if (parts[0].length >= 3) {
        month = parts[0].substring(0, 3).toUpperCase();
      } else {
        month = parts[0].toUpperCase();
      }
    }
    if (parts.length > 1) {
      day = parts[1].replaceAll(',', '');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          // Date block on Left
          Container(
            width: 54,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: tt.titleLarge?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                Text(
                  month,
                  style: tt.labelSmall?.copyWith(
                    color: cs.primary.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Title and Location on Right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: cs.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (hours != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: cs.secondary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+$hours hrs',
                style: tt.labelMedium?.copyWith(
                  color: cs.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
