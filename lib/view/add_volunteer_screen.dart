import 'package:flutter/material.dart';
import 'package:nss_new/common_pages/appbar.dart';

class AddVolunteerScreen extends StatelessWidget {
  const AddVolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppBar(),
        // bottomNavigationBar: CustomNavBar(currentIndex: 4),
      ),
    );
  }
}
