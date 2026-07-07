import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss_new/api.dart';
import 'package:nss_new/model/department_model.dart';
import 'package:nss_new/model/volunteer_model.dart';
import 'package:nss_new/model/user_model.dart';
import 'package:nss_new/common_pages/custom_decorations.dart';
import 'package:nss_new/view/add_volunteer_screen.dart';
import 'package:nss_new/view/profile_screen.dart';

class VolunteerController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController admissionNoController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController casteController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  var isUpdateButtonLoading = false.obs;
  var isDeleteButtonLoading = false.obs;
  DateTime? dob;
  final api = Api();
  RxString role = 'vol'.obs;
  RxString caste = ''.obs;
  RxString gender = ''.obs;
  RxList<Department> departmentList = <Department>[].obs;
  RxnString selectedCaste = RxnString();
  RxnString selectedGender = RxnString();

  int? departmentID;

  @override
  void onInit() {
    getDepartments();
    super.onInit();
  }

  void getDepartments() async {
    api.getDepartments().then((value) {
      departmentList.assignAll(value?.programs?.toList() ?? []);
    });
  }

  void addVolunteer() async {
    isUpdateButtonLoading.value = true;
    api
        .addVolunteer({
          'admission_number': admissionNoController.text,
          'name': nameController.text,
          'email': emailController.text,
          'phone_number': phoneController.text,
          'date_of_birth': dob.toString(),
          'department': departmentID,
          'roll_number': '1',
          'role': role.value,
          'year': yearController.text,
          'caste': casteController.text,
          'gender': genderController.text,
        })
        .then((value) {
          isUpdateButtonLoading.value = false;
          Get.back();
          if (value?.status ?? false) {
            Get.back();
            CustomWidgets.showSnackBar(
              'Success',
              value?.message ?? 'Volunteer added successfully.',
            );
          } else {
            CustomWidgets.showSnackBar(
              'Error',
              value?.message ?? 'Failed to add volunteer.',
            );
          }
        });
  }

  void updateVolunteer() async {
    isUpdateButtonLoading.value = true;
    api
        .updateVolunteer({
          'admission_number': admissionNoController.text,
          'name': nameController.text,
          'email': emailController.text,
          'phone_number': phoneController.text,
          'date_of_birth': dob.toString(),
          'department': departmentID,
          'roll_number': rollNoController.text,
          'role': role.value,
          'year': yearController.text,
          'caste': casteController.text,
          'gender': genderController.text,
        })
        .then((response) {
          isUpdateButtonLoading.value = false;
          Get.back();
          if (response?.status == true) {
            Get.back();
            CustomWidgets.showSnackBar(
              'Success',
              response?.message ?? 'Volunteer updated successfully.',
            );
          } else {
            CustomWidgets.showSnackBar(
              'Error',
              response?.message ?? 'Failed to update volunteer.',
            );
          }
        });
  }

  void deleteVolunteer() async {
    isDeleteButtonLoading.value = true;
    api.deleteVolunteer(admissionNoController.text).then((response) {
      isDeleteButtonLoading.value = false;

      if (response?.status ?? false) {
        Get.back();
        Get.back();
        CustomWidgets.showSnackBar(
          "Success",
          response?.message ?? "Volunteer deleted successfully.",
        );
      } else {
        CustomWidgets.showSnackBar(
          "Error",
          response?.message ?? "Failed to delete volunteer.",
        );
      }
    });
  }

  void setUpdateData(Users user) {
    nameController.text = user.name ?? "";
    emailController.text = user.email ?? "";
    phoneController.text = user.phoneNo ?? "";
    departmentID = user.department?.id;
    departmentController.text =
        "${user.department?.category ?? ''} ${user.department?.name ?? ''}";
    rollNoController.text = user.rollNo?.toString() ?? "";
    admissionNoController.text = user.admissionNo ?? "";
    dobController.text = (user.dob != null)
        ? DateFormat.yMMMd().format(user.dob!)
        : "";
    dob = user.dob;
    role.value = user.role ?? 'vol';
    yearController.text = user.year ?? "";
    casteController.text = user.caste ?? "";
    genderController.text = user.gender ?? "";
    selectedCaste.value = user.caste;
    selectedGender.value = user.gender;
  }

  void clearTextFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    departmentController.clear();
    rollNoController.clear();
    admissionNoController.clear();
    dobController.clear();
    yearController.clear();
    casteController.clear();
    genderController.clear();
    selectedCaste.value = null;
    selectedGender.value = null;
    role.value = 'vol';
  }

  bool onSubmitVolValidation() {
    if (nameController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter name');
      return false;
    }
    if (emailController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter email');
      return false;
    }
    if (phoneController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter phone number');
      return false;
    }
    if (casteController.text.isEmpty &&
        (selectedCaste.value == null || selectedCaste.value!.isEmpty)) {
      CustomWidgets.showSnackBar('Invalid', 'Please select caste');
      return false;
    }
    if (genderController.text.isEmpty &&
        (selectedGender.value == null || selectedGender.value!.isEmpty)) {
      CustomWidgets.showSnackBar('Invalid', 'Please select gender');
      return false;
    }
    if ((departmentID ?? "").toString().isEmpty ||
        departmentController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please add department');
      return false;
    }
    if (admissionNoController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please add admission number');
      return false;
    }
    if (dobController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please add date of birth');
      return false;
    }
    if (yearController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please add year of study');
      return false;
    }
    return true;
  }
}

class VolunteerListController extends GetxController {
  TextEditingController searchController = TextEditingController();

  RxBool isLoading = true.obs;
  RxList<Volunteer> usersList = <Volunteer>[].obs;
  RxList<Volunteer> searchList = <Volunteer>[].obs;
  RxList<String> departmentList = <String>[].obs;

  String _currentQuery = '';
  RxString sortBy = ''.obs;
  RxString selectedBloodGroup = ''.obs;
  RxString selectedLocation = ''.obs;

  List<String> get bloodGroups => [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  List<String> get locations {
    return usersList
        .map((e) => e.address ?? '')
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() {
    isLoading.value = true;
    Api().getVolunteers().then((value) {
      final data = value?.data
          ?.where((element) => element.role != 'po')
          .toList();
      usersList.assignAll(data ?? []);
      _applyFilterAndSort();
      isLoading.value = false;
    });
  }

  void updateVolunteer(String? admissionNo) {
    Api().volunteerDetails(admissionNo!).then((value) {
      if (value?.volunteerDetails != null) {
        Get.to(
          () => AddVolunteerScreen(volunteer: value!.volunteerDetails),
        )?.then((value) => getData());
      }
    });
  }

  void onSearchTextChanged(String value) {
    _currentQuery = value;
    _applyFilterAndSort();
  }

  void setSortOption(String option) {
    if (sortBy.value == option) {
      sortBy.value = '';
    } else {
      sortBy.value = option;
    }
    _applyFilterAndSort();
  }

  String getMockBloodGroup(String name) {
    final groups = ['O+', 'A+', 'B+', 'AB+', 'O-', 'A-', 'B-', 'AB-'];
    return groups[name.length % groups.length];
  }

  void _applyFilterAndSort() {
    List<Volunteer> filtered = [];
    if (_currentQuery.isEmpty) {
      filtered = List.from(usersList);
    } else {
      final query = _currentQuery.toLowerCase();
      filtered = usersList.where((volunteer) {
        final name = volunteer.name?.toLowerCase() ?? '';
        final admnNo = volunteer.admissionNo?.toLowerCase() ?? '';
        final bloodGroup = volunteer.bloodGroup?.toLowerCase() ?? '';
        final address = volunteer.address?.toLowerCase() ?? '';

        return name.contains(query) ||
            admnNo.contains(query) ||
            bloodGroup.contains(query) ||
            address.contains(query);
      }).toList();
    }

    if (sortBy.value == 'bloodGroup') {
      filtered.sort((a, b) {
        final bgA = a.bloodGroup ?? '';
        final bgB = b.bloodGroup ?? '';
        return bgA.compareTo(bgB);
      });
    } else if (sortBy.value == 'location') {
      filtered.sort((a, b) {
        final addrA = a.address ?? '';
        final addrB = b.address ?? '';
        return addrA.compareTo(addrB);
      });
    }

    if (selectedBloodGroup.value.isNotEmpty) {
      filtered = filtered.where((v) {
        return getMockBloodGroup(v.name ?? '') == selectedBloodGroup.value;
      }).toList();
    }

    if (selectedLocation.value.isNotEmpty) {
      filtered = filtered.where((v) {
        return v.address == selectedLocation.value;
      }).toList();
    }

    searchList.assignAll(filtered);
  }

  void viewVolunteerProfile(String? admissionNo) {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    Api().volunteerDetails(admissionNo!).then((value) {
      Get.back();
      if (value?.volunteerDetails != null) {
        Get.to(
          () => ProfileScreen(volunteer: value!.volunteerDetails),
        )?.then((_) => getData());
      } else {
        CustomWidgets.showSnackBar("Error", "Failed to load volunteer details");
      }
    });
  }

  void sortByBloodGroup(String group) {
    selectedBloodGroup.value = group;
    selectedLocation.value = '';
    _applyFilterAndSort();
  }

  void sortByLocation(String location) {
    selectedLocation.value = location;
    selectedBloodGroup.value = '';
    _applyFilterAndSort();
  }

  void clearSort() {
    selectedBloodGroup.value = '';
    selectedLocation.value = '';
    sortBy.value = '';
    _applyFilterAndSort();
  }
}
