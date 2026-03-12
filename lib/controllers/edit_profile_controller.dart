import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../routes/app_routes.dart';
import 'home_controller.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final RxString name = "".obs;
  final RxString email = "".obs;
  final RxString phone = "".obs;
  final RxString currentImageUrl = "".obs;

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
            currentImageUrl.value = data['profile_picture'] ?? data['image'] ?? data['avatar'] ?? '';
            
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
    
    // Create FormData object to handle both text fields and the image file
    final formData = FormData({
      'full_name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
    });

    // If a new image was picked, append it as a MultipartFile
    if (pickedImagePath.value.isNotEmpty) {
      formData.files.add(MapEntry(
        'profile_picture', // Replace with exact backend field name (e.g., 'image', 'avatar', 'profile_picture')
        MultipartFile(pickedImagePath.value, filename: pickedImagePath.value.split('/').last),
      ));
    }

    isSaving.value = true;

    // Use the new API service method that accepts FormData
    apiService.updateProfileWithImage(formData).listen(
      (response) {
        isSaving.value = false;
        
        debugPrint('UpdateProfile Status Code: ${response.statusCode}');
        debugPrint('UpdateProfile Response Body: ${response.body}');
        
        if (response.statusCode == 200 || response.statusCode == 204) {
          name.value = nameController.text;
          phone.value = phoneController.text;
          
          // Refresh the global home controller and set its index to Profile section
          if (Get.isRegistered<HomeController>()) {
            final homeCtrl = Get.find<HomeController>();
            homeCtrl.fetchUserProfile();
            homeCtrl.changeTabIndex(3); // Set to Profile tab
          }

          Get.snackbar(
            'Success',
            'Profile updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          
          Get.offAllNamed(Routes.home);
        } else {
          String errorMsg = 'Could not update profile';
          if (response.body != null) {
            if (response.body is Map) {
              if (response.body['message'] != null) {
                errorMsg = response.body['message'].toString();
              } else if (response.body['detail'] != null) {
                errorMsg = response.body['detail'].toString();
              } else {
                // It's likely a field validation error like {"phone": ["Invalid format"]}
                var errors = [];
                (response.body as Map).forEach((key, value) {
                  if (value is List) {
                    errors.add(value.join('\n'));
                  } else {
                    errors.add(value.toString());
                  }
                });
                errorMsg = errors.join('\n');
              }
            } else {
              errorMsg = response.body.toString();
            }
          }
          Get.snackbar(
            'Update Failed',
            errorMsg,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      onError: (error) {
        isSaving.value = false;
        debugPrint('UpdateProfile Error: $error');
        Get.snackbar('Error', 'An unexpected error occurred: $error');
      },
    );
  }
}
