import 'package:flutter/material.dart';
import 'package:nss_new/common_pages/navbar.dart';
import 'package:nss_new/view/home_screen.dart';

class IssuesScreen extends StatefulWidget {
  const IssuesScreen({super.key});

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedIssueType = 'Attendance discrepancy';
  String _sendTo = 'Secretary'; // 'Secretary' or 'Program Officer'

  final List<Map<String, String>> reportedIssues = [
    {
      'title': 'Damaged Classroom Projector',
      'description':
          'The projector in Seminar Hall A is not functioning properly, affecting presentations and workshops.',
      'date': 'June 20, 2026',
      'reportedTo': 'Secretary',
      'status': 'Pending',
    },
    {
      'title': 'Overflowing Waste Bins',
      'description':
          'Waste bins near the canteen have not been emptied for several days, causing hygiene concerns.',
      'date': 'June 22, 2026',
      'reportedTo': 'Program Officer',
      'status': 'Resolved',
    },
    {
      'title': 'Water Leakage in Corridor',
      'description':
          'A continuous water leak has been observed near the Science Block corridor, making the floor slippery.',
      'date': 'June 23, 2026',
      'reportedTo': 'Secretary',
      'status': 'Resolved',
    },
    {
      'title': 'Broken Street Light',
      'description':
          'The street light near the main gate is not working, reducing visibility during evening hours.',
      'date': 'June 24, 2026',
      'reportedTo': 'Program Officer',
      'status': 'Pending',
    },
    {
      'title': 'Insufficient Drinking Water',
      'description':
          'The water dispenser near the library frequently runs out of drinking water during peak hours.',
      'date': 'June 25, 2026',
      'reportedTo': 'Secretary',
      'status': 'Pending',
    },
    {
      'title': 'Classroom Fan Not Working',
      'description':
          'Two ceiling fans in Room 204 are not functioning, causing discomfort during lectures.',
      'date': 'June 26, 2026',
      'reportedTo': 'Program Officer',
      'status': 'Resolved',
    },
    {
      'title': 'Damaged Campus Bench',
      'description':
          'A bench near the central garden has broken wooden planks and requires immediate repair.',
      'date': 'June 27, 2026',
      'reportedTo': 'Secretary',
      'status': 'Pending',
    },
    {
      'title': 'Parking Area Congestion',
      'description':
          'Improper parking near the main entrance is causing traffic congestion during college hours.',
      'date': 'June 28, 2026',
      'reportedTo': 'Program Officer',
      'status': 'Pending',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Filter reported issues based on search query
    final filteredIssues = reportedIssues.where((p) {
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: cs.surface,
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Navigation & Search Bar (Fixed)
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
                            hintText: 'Search issues...',
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

              // Title and Subtitle Section (Fixed)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support Center',
                      style: tt.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Report new issues or track the status of existing issues.',
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Report New Issue Form Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cs.outline.withOpacity(0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report New Issue',
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Issue Type',
                        style: tt.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Issue Type Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedIssueType,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: cs.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: cs.outline.withOpacity(0.5),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: cs.outline.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: cs.primary),
                          ),
                        ),
                        dropdownColor: cs.surface,
                        items:
                            [
                                  'Attendance discrepancy',
                                  'Event registration error',
                                  'App/Technical issue',
                                  'General query',
                                ]
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type, style: tt.bodyMedium),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedIssueType = val),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Description',
                        style: tt.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Description text field
                      TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: cs.surface,
                          hintText: 'Describe the issue...',
                          hintStyle: tt.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(0.4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: cs.outline.withOpacity(0.5),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: cs.outline.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: cs.primary),
                          ),
                        ),
                        style: tt.bodyMedium,
                      ),
                      const SizedBox(height: 10),

                      // Send to (Secretary or Program Officer) choice chips
                      Row(
                        children: [
                          Text(
                            'Send to: ',
                            style: tt.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildSendToChip('Secretary'),
                          const SizedBox(width: 8),
                          _buildSendToChip('Program Officer'),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: FilledButton(
                          onPressed: () {
                            if (_descriptionController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a description'),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              reportedIssues.insert(0, {
                                'title': _selectedIssueType ?? 'General Issue',
                                'description': _descriptionController.text
                                    .trim(),
                                'date': 'June 26, 2026',
                                'reportedTo': _sendTo,
                                'status': 'Pending',
                              });
                              _descriptionController.clear();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Issue reported successfully'),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: cs.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Submit Report',
                            style: tt.labelLarge?.copyWith(
                              color: cs.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // My Reported Issues Section Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'My Reported Issues',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              if (filteredIssues.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'No issues reported',
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredIssues.length,
                  itemBuilder: (context, index) {
                    final issue = filteredIssues[index];

                    return _buildReportedIssueCard(
                      context: context,
                      title: issue['title'] ?? '',
                      description: issue['description'] ?? '',
                      date: issue['date'] ?? '',
                      reportedTo: issue['reportedTo'] ?? '',
                      status: issue['status'] ?? 'Pending',
                      cs: cs,
                      tt: tt,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSendToChip(String role) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isSelected = _sendTo == role;

    return ChoiceChip(
      showCheckmark: false,
      label: Text(role),
      selected: isSelected,
      labelStyle: tt.bodySmall?.copyWith(
        color: isSelected ? cs.onPrimary : cs.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      selectedColor: cs.primary,
      backgroundColor: cs.outline.withOpacity(0.12),
      side: BorderSide(
        color: isSelected ? Colors.transparent : cs.outline,
        width: 1,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _sendTo = role;
          });
        }
      },
    );
  }

  Widget _buildReportedIssueCard({
    required BuildContext context,
    required String title,
    required String description,
    required String date,
    required String reportedTo,
    required String status,
    required ColorScheme cs,
    required TextTheme tt,
  }) {
    final isResolved = status.toLowerCase() == 'resolved';
    final statusColor = isResolved
        ? Colors.green.shade700
        : Colors.orange.shade700;
    final statusBg = isResolved ? Colors.green.shade50 : Colors.orange.shade50;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: tt.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Description (One Line)
          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tt.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.6)),
          ),
          const SizedBox(height: 10),

          // Footer (Date, Recipient, View Details)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: cs.onSurface.withOpacity(0.4),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: tt.bodySmall?.copyWith(
                        fontSize: 10,
                        color: cs.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.person_outline,
                      size: 12,
                      color: cs.onSurface.withOpacity(0.4),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'To: $reportedTo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.bodySmall?.copyWith(
                          fontSize: 10,
                          color: cs.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        title,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status: ',
                                style: tt.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status,
                                  style: tt.labelSmall?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Reported on: $date', style: tt.bodySmall),
                          const SizedBox(height: 4),
                          Text('Sent to: $reportedTo', style: tt.bodySmall),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(description, style: tt.bodyMedium),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  children: [
                    Text(
                      'View Details',
                      style: tt.labelSmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 14, color: cs.primary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
