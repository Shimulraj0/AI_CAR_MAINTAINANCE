import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final RxString name = "".obs;
  final RxString email = "".obs;
  final RxString phone = "".obs;

  var isLoading = false.obs;
  var isSaving = false.obs;

  // Observable for the selected image path
  final RxString pickedImagePath = "".obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void fetchProfile() {
    final apiService = Get.find<ApiService>();
    isLoading.value = true;
    
    apiService.getProfile().listen(
      (response) {
        isLoading.value = false;
        if (response.statusCode == 200) {
          final data = response.body;
          if (data != null) {
            name.value = data['full_name'] ?? data['name'] ?? '';
            email.value = data['email'] ?? '';
            phone.value = data['phone'] ?? '';
            
            nameController.text = name.value;
            emailController.text = email.value;
            phoneController.text = phone.value;
          }
        } else {
          Get.snackbar('Error', 'Failed to fetch profile data');
        }
      },
      onError: (error) {
        isLoading.value = false;
        Get.snackbar('Error', 'An unexpected error occurred: $error');
      },
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void saveChanges() {
    final apiService = Get.find<ApiService>();
    
    final payload = {
      'full_name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      // 'email': emailController.text.trim(), // Usually email is not partially updated, but can be added if backend supports it.
    };

    isSaving.value = true;

    apiService.partialUpdateProfile(payload).listen(
      (response) {
        isSaving.value = false;
        if (response.statusCode == 200 || response.statusCode == 204) {
          name.value = nameController.text;
          phone.value = phoneController.text;
          
          Get.snackbar(
            'Success',
            'Profile updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          
          Future.delayed(const Duration(milliseconds: 1500), () {
            Get.back();
          });
        } else {
          Get.snackbar(
            'Update Failed',
            response.body?['message'] ?? 'Could not update profile',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      onError: (error) {
        isSaving.value = false;
        Get.snackbar('Error', 'An unexpected error occurred: $error');
      },
    );
  }
}
