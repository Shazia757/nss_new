import 'package:get/get.dart';
import 'package:nss_new/api.dart';
import 'package:nss_new/model/user_model.dart';

class VolunteerController extends GetxController  {
  RxBool isLoading = true.obs;
  RxList<Users> volunteersList = <Users>[].obs;


  @override
  void onInit() {
    getData();
    super.onInit();
  }

void getData() {
    isLoading.value = true;
    Api().getVolunteers().then(
      (value) {
        final data =
            value?.data?.where((element) => element.role != 'po').toList();
        volunteersList.assignAll(data ?? []);
        // searchList.assignAll(usersList);
        isLoading.value = false;
      },
    );
  }

  // final RxList<Map<String, String>> volunteerDetailsList = [
  //   {
  //     'admissionNo': 'FCBSC001',
  //     'name': 'Aisha Rahman',
  //     'email': 'aisha.rahman@farookcollege.ac.in',
  //     'program': 'B.Voc Software Development',
  //     'year': '2nd Year',
  //     'phone': '+91 9876543210',
  //     'caste': 'General',
  //     'gender': 'Female',
  //     'dob': '12 March 2006',
  //     'bloodGroup': 'O+',
  //   },
  //   {
  //     'admissionNo': 'FCBSC002',
  //     'name': 'Muhammed Shamil',
  //     'email': 'muhammed.shamil@farookcollege.ac.in',
  //     'program': 'B.Sc Computer Science',
  //     'year': '3rd Year',
  //     'phone': '+91 9876543211',
  //     'caste': 'OBC',
  //     'gender': 'Male',
  //     'dob': '24 July 2005',
  //     'bloodGroup': 'A+',
  //   },
  //   {
  //     'admissionNo': 'FCBSC003',
  //     'name': 'Fathima Nisa',
  //     'email': 'fathima.nisa@farookcollege.ac.in',
  //     'program': 'B.Com Finance',
  //     'year': '1st Year',
  //     'phone': '+91 9876543212',
  //     'caste': 'Muslim',
  //     'gender': 'Female',
  //     'dob': '08 November 2007',
  //     'bloodGroup': 'B+',
  //   },
  //   {
  //     'admissionNo': 'FCBSC004',
  //     'name': 'Adil Mohammed',
  //     'email': 'adil.mohammed@farookcollege.ac.in',
  //     'program': 'B.Voc Software Development',
  //     'year': '2nd Year',
  //     'phone': '+91 9876543213',
  //     'caste': 'Muslim',
  //     'gender': 'Male',
  //     'dob': '30 January 2006',
  //     'bloodGroup': 'AB+',
  //   },
  //   {
  //     'admissionNo': 'FCBSC005',
  //     'name': 'Jishad Ali',
  //     'email': 'jishad.ali@farookcollege.ac.in',
  //     'program': 'BCA',
  //     'year': '3rd Year',
  //     'phone': '+91 9876543214',
  //     'caste': 'OBC',
  //     'gender': 'Male',
  //     'dob': '17 May 2005',
  //     'bloodGroup': 'O-',
  //   },
  //   {
  //     'admissionNo': 'FCBSC006',
  //     'name': 'Anagha S',
  //     'email': 'anagha.s@farookcollege.ac.in',
  //     'program': 'B.A English',
  //     'year': '2nd Year',
  //     'phone': '+91 9876543215',
  //     'caste': 'General',
  //     'gender': 'Female',
  //     'dob': '09 September 2006',
  //     'bloodGroup': 'A-',
  //   },
  //   {
  //     'admissionNo': 'FCBSC007',
  //     'name': 'Arjun Krishna',
  //     'email': 'arjun.krishna@farookcollege.ac.in',
  //     'program': 'B.Sc Mathematics',
  //     'year': '1st Year',
  //     'phone': '+91 9876543216',
  //     'caste': 'SC',
  //     'gender': 'Male',
  //     'dob': '14 February 2007',
  //     'bloodGroup': 'B-',
  //   },
  //   {
  //     'admissionNo': 'FCBSC008',
  //     'name': 'Hiba Mariyam',
  //     'email': 'hiba.mariyam@farookcollege.ac.in',
  //     'program': 'B.Com Computer Applications',
  //     'year': '2nd Year',
  //     'phone': '+91 9876543217',
  //     'caste': 'Muslim',
  //     'gender': 'Female',
  //     'dob': '21 June 2006',
  //     'bloodGroup': 'AB-',
  //   },
  //   {
  //     'admissionNo': 'FCBSC009',
  //     'name': 'Nihal K',
  //     'email': 'nihal.k@farookcollege.ac.in',
  //     'program': 'B.Sc Physics',
  //     'year': '3rd Year',
  //     'phone': '+91 9876543218',
  //     'caste': 'OBC',
  //     'gender': 'Male',
  //     'dob': '03 December 2005',
  //     'bloodGroup': 'O+',
  //   },
  //   {
  //     'admissionNo': 'FCBSC010',
  //     'name': 'Safa Parveen',
  //     'email': 'safa.parveen@farookcollege.ac.in',
  //     'program': 'B.Voc Software Development',
  //     'year': '1st Year',
  //     'phone': '+91 9876543219',
  //     'caste': 'General',
  //     'gender': 'Female',
  //     'dob': '28 August 2007',
  //     'bloodGroup': 'A+',
  //   },
  // ].obs;
}
