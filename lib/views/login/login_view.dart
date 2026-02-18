import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered if not using bindings
    if (!Get.isRegistered<LoginController>()) {
      Get.put(LoginController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Log In',
          style: TextStyle(
            color: Color(0xFF2B63A8),
            fontSize: 18,
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Below Header Space (overlapping if needed, or simple column)
            // Using standard column layout for simplicity first, can adjust for overlap if critical.
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back !',
                      style: TextStyle(
                        color: Color(0xFF2B63A8),
                        fontSize: 20,
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

                    // Email Field
                    _buildLabel('Email'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        hintText: 'brooklynsim@gm |',
                        hintStyle: const TextStyle(color: Color(0xFF0F0F0F)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD2D6DB),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) => GetUtils.isEmail(value ?? '')
                          ? null
                          : 'Please enter a valid email',
                    ),
                    const SizedBox(height: 24),

                    // Password Field
                    _buildLabel('Password'),
                    const SizedBox(height: 8),
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.isPasswordHidden.value,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          hintStyle: const TextStyle(color: Color(0xFF0F0F0F)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFD2D6DB),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordHidden.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF949CA9),
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) => (value?.length ?? 0) >= 6
                            ? null
                            : 'Password must be at least 6 chars',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (val) =>
                                    controller.toggleRememberMe(),
                                activeColor: const Color(0xFF2B63A8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                color: Color(0xFF0F0F0F),
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: controller.navigateToForgotPassword,
                          child: const Text(
                            'Forgot password ?',
                            style: TextStyle(
                              color: Color(0xFF0F0F0F),
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2B63A8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Sign in',
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
                        'Or ',
                        style: TextStyle(
                          color: Color(0xFF2B63A8),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Social Logins (Placeholders)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialButton(
                          SvgPicture.asset('assets/images/Google.svg'),
                        ),
                        const SizedBox(width: 16),
                        _socialButton(
                          SvgPicture.asset('assets/images/Frame 26.svg'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don’t have account? ",
                          style: TextStyle(
                            color: Color(0xFF2B63A8),
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.navigateToSignUp,
                          child: const Text(
                            'Sign up',
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

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF0F0F0F),
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _socialButton(Widget icon) {
    return Container(
      width: 46,
      height: 46,
      decoration: const ShapeDecoration(
        color: Color(0xFFE5E7EB),
        shape: OvalBorder(),
      ),
      child: Center(child: icon),
    );
  }
}
