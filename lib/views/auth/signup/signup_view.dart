import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controllers/signup_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    if (!Get.isRegistered<SignUpController>()) {
      Get.put(SignUpController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Registration',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2B63A8),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Form(
                key: controller.signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Register Account',
                      style: TextStyle(
                        color: Color(0xFF2B63A8),
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in with your email and password \nor social media to continue',
                      style: TextStyle(
                        color: Color(0xFF949CA9),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Name Field
                    TextFormField(
                      controller: controller.nameController,
                      decoration: _inputDecoration('Full Name', 'Your Name'),
                      validator: (value) => (value?.isEmpty ?? true)
                          ? 'Please enter your name'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // Email Field
                    TextFormField(
                      controller: controller.emailController,
                      decoration: _inputDecoration('Email', 'brooklynsim@gm |'),
                      validator: (value) => GetUtils.isEmail(value ?? '')
                          ? null
                          : 'Please enter a valid email',
                    ),
                    const SizedBox(height: 24),

                    // Password Field
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.isPasswordHidden.value,
                        decoration: _inputDecoration('Password', '••••••••')
                            .copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordHidden.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF949CA9),
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            ),
                        validator: (value) => (value?.length ?? 0) >= 6
                            ? null
                            : 'Password must be at least 6 chars',
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Confirm Password Field
                    Obx(
                      () => TextFormField(
                        controller: controller.confirmPasswordController,
                        obscureText: controller.isConfirmPasswordHidden.value,
                        decoration:
                            _inputDecoration(
                              'Confirm Password',
                              '••••••••',
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isConfirmPasswordHidden.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF949CA9),
                                ),
                                onPressed:
                                    controller.toggleConfirmPasswordVisibility,
                              ),
                            ),
                        validator: (value) {
                          if (value != controller.passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Terms Checkbox
                    Row(
                      children: [
                        Obx(
                          () => SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: controller.agreeToTerms.value,
                              onChanged: (val) => controller.toggleTerms(),
                              activeColor: Colors.black,
                              checkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Agree with ',
                                style: TextStyle(
                                  color: Color(0xFF0F0F0F),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              TextSpan(
                                text: 'terms ',
                                style: TextStyle(
                                  color: Color(0xFF0F0F0F),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: 'and ',
                                style: TextStyle(
                                  color: Color(0xFF0F0F0F),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              TextSpan(
                                text: 'privacy',
                                style: TextStyle(
                                  color: Color(0xFF0F0F0F),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: controller.signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2B63A8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'Or',
                        style: TextStyle(
                          color: Color(0xFF2B63A8),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Social Logins
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialCircleButton(
                          SvgPicture.asset(
                            'assets/images/Google.svg',
                            width: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        _socialCircleButton(
                          SvgPicture.asset(
                            'assets/images/Frame 26.svg',
                            width: 24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Sign In Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Color(0xFF2B63A8),
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.navigateToSignIn,
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              color: Color(0xFF2B63A8),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF0F0F0F),
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF949CA9), fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD2D6DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD2D6DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2B63A8), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _socialCircleButton(Widget icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Center(child: icon),
    );
  }
}
