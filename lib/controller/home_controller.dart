import 'package:get/get.dart';
import 'package:nss_new/api.dart';
import 'package:nss_new/model/programs_model.dart';
import 'package:nss_new/common_pages/custom_decorations.dart';

class HomeController extends GetxController {
  RxList<Program> upcomingPrograms = <Program>[].obs;
  RxBool isLoading = true.obs;
  RxBool isEnrolledLoading = false.obs;

  @override
  void onInit() {
    fetchUpcomingPrograms();
    super.onInit();
  }

  void fetchUpcomingPrograms() async {
    isLoading.value = true;
    upcomingPrograms.clear();
   Api().getUpcomingPrograms().then(
      (value) {
        upcomingPrograms.assignAll(value?.programs ?? []);
        upcomingPrograms.sort((a, b) => b.date!.compareTo(a.date!));
        isLoading.value = false;
      },
    );
  }

  void enroll(Program program) async {
    isEnrolledLoading.value = true;
   Api().enrollToProgram({'program': program.id}).then(
      (response) {
        isEnrolledLoading.value = false;
        Get.back();
        if (response?.status == true) {
          Get.back();
          CustomWidgets.showSnackBar(
              'Success', response?.message ?? 'You are enrolled.');
        } else {
          CustomWidgets.showSnackBar(
              'Error', response?.message ?? 'Failed to enroll.');
        }
      },
    );
  }
}
