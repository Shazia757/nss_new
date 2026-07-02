import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss_new/common_pages/navbar.dart';
import 'package:nss_new/controller/volunteer_controller.dart';
import 'package:nss_new/database/local_storage.dart';
import 'package:nss_new/model/user_model.dart';
import 'package:nss_new/view/add_volunteer_screen.dart';
import 'package:nss_new/view/authentication/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Users? volunteer;

  const ProfileScreen({super.key, this.volunteer});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final volunteerController = Get.isRegistered<VolunteerController>()
        ? Get.find<VolunteerController>()
        : Get.put(VolunteerController());

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: (volunteer == null)
          ? const CustomBottomNavBar(currentIndex: 4)
          : SizedBox(),
      body: SafeArea(
        child: Obx(() {
          final admissionNo = LocalStorage().readUser().admissionNo;

          final loggedInVolunteer = volunteerController.volunteersList
              .firstWhereOrNull((v) => v.admissionNo == admissionNo);

          final displayVol = volunteer ?? loggedInVolunteer;
          final name = displayVol?.name;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                children: [
                  /// ── PROFILE HERO CARD ──────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [cs.primary, cs.primary.withOpacity(0.78)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        // Subtle circle decoration
                        Positioned(
                          top: -30,
                          right: -30,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.07),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -20,
                          left: -20,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.07),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                          child: Column(
                            children: [
                              // Avatar
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.35),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.18),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 42,
                                  backgroundColor: Colors.white.withOpacity(.2),
                                  child: Text(
                                    (name != null && name.isNotEmpty)
                                        ? name.substring(0, 1).toUpperCase()
                                        : "S",
                                    style: tt.headlineLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Name
                              Text(
                                displayVol?.name ?? "Shazia",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                              ),

                              const SizedBox(height: 4),

                              // Role pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Volunteer",
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        letterSpacing: 0.3,
                                      ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Action Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () {},
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.18),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.lock_reset_rounded,
                                      ),
                                      label: const Text("Change Password"),
                                    ),
                                  ),
                                  if (displayVol != null) ...[
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: FilledButton.icon(
                                        onPressed: () {
                                          // Get.to(
                                          //   () => AddVolunteerScreen(
                                          //     volunteer: Map<String, String>.from(
                                          //       displayVol,
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                        style: FilledButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: cs.primary,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        icon: const Icon(Icons.edit_rounded),
                                        label: const Text("Edit Profile"),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= PERSONAL DETAILS =================
                  _SectionCard(
                    title: "Personal Details",
                    icon: Icons.person_outline_rounded,
                    child: Column(
                      children: [
                        _InfoRow(
                          label: "Gender",
                          value: displayVol?.gender ?? "Female",
                          icon: Icons.wc_rounded,
                        ),
                        const _Divider(),

                        _InfoRow(
                          label: "Date of Birth",
                          value: (displayVol?.dob.toString()) ?? "18 May 2005",
                          icon: Icons.cake_outlined,
                        ),
                        const _Divider(),

                        _InfoRow(
                          label: "Caste",
                          value: displayVol?.caste ?? "General",
                          icon: Icons.groups_outlined,
                        ),
                        const _Divider(),

                        _InfoRow(
                          label: "Blood Group",
                          value: displayVol?.bloodGroup ?? "O+",
                          icon: Icons.bloodtype_outlined,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  _SectionCard(
                    title: "Academic Details",
                    icon: Icons.school_outlined,
                    child: Column(
                      children: [
                        _InfoRow(
                          label: "Programme",
                          value:
                              "${displayVol?.department?.category} ${displayVol?.department?.name}",
                          icon: Icons.menu_book_outlined,
                        ),
                        const _Divider(),

                        _InfoRow(
                          label: "Year of Study",
                          value: displayVol?.year ?? "Second Year",
                          icon: Icons.calendar_today_outlined,
                        ),
                        const _Divider(),

                        _InfoRow(
                          label: "Admission No.",
                          value: displayVol?.admissionNo ?? "BVSD240015",
                          icon: Icons.badge_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionCard(
                    title: "Contact",
                    icon: Icons.contact_phone_outlined,
                    child: Column(
                      children: [
                        _InfoRow(
                          label: "Email",
                          value: displayVol?.email ?? "shazia@example.com",
                          icon: Icons.mail_outline_rounded,
                        ),
                        const _Divider(),

                        _InfoRow(
                          label: "Phone Number",
                          value: displayVol?.phoneNo ?? "+91 98765 43210",
                          icon: Icons.phone_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// ── DANGER ZONE ────────────────────────────────────────
                  if (volunteer == null) _DangerZoneCard(cs: cs),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SECTION CARD
// ─────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: cs.primary),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// INFO ROW
// ─────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.primary.withOpacity(0.7)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DANGER ZONE CARD
// ─────────────────────────────────────────────────────────────
class _DangerZoneCard extends StatelessWidget {
  final ColorScheme cs;

  const _DangerZoneCard({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.errorContainer.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.error.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.logout_rounded, size: 20, color: cs.error),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign out",
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: cs.error),
                ),
                SizedBox(height: 2),
                Text(
                  "You will need to log in again to access your account.",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: cs.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          TextButton(
            onPressed: () {
              LocalStorage().clearAll();
              Get.offAll(() => LoginScreen());
            },
            style: TextButton.styleFrom(
              foregroundColor: cs.error,
              backgroundColor: cs.error.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Logout",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// THIN DIVIDER
// ─────────────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.8,
      color: Theme.of(context).colorScheme.outline.withOpacity(.3),
    );
  }
}
