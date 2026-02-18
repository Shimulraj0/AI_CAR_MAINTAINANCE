import 'package:get/get.dart';
import '../views/home/home_view.dart';
import '../views/splash/splash_view.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/login/login_view.dart';
import '../controllers/login_controller.dart';
import '../views/signup/signup_view.dart';
import '../controllers/signup_controller.dart';
import '../views/forgot_password/forgot_password_view.dart';
import '../controllers/forgot_password_controller.dart';
import '../views/verify_email/verify_email_view.dart';
import '../controllers/verify_email_controller.dart';
import '../views/change_password/change_password_view.dart';
import '../views/change_password/password_reset_success_view.dart';
import '../controllers/change_password_controller.dart';
import '../views/vehicle_registration/vehicle_registration_view.dart';
import '../controllers/vehicle_registration_controller.dart';
import '../views/important_notice/important_notice_view.dart';
import '../controllers/important_notice_controller.dart';
import '../bindings/initial_binding.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: InitialBinding(),
    ),
    GetPage(name: Routes.splash, page: () => const SplashView()),
    GetPage(name: Routes.onboarding, page: () => const OnboardingView()),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignUpView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SignUpController>(() => SignUpController());
      }),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
      }),
    ),
    GetPage(
      name: Routes.verifyEmail,
      page: () => const VerifyEmailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<VerifyEmailController>(() => VerifyEmailController());
      }),
    ),
    GetPage(
      name: Routes.changePassword,
      page: () => const ChangePasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
      }),
    ),
    GetPage(
      name: Routes.changePasswordSuccess,
      page: () => const PasswordResetSuccessView(),
    ),
    GetPage(
      name: Routes.vehicleRegistration,
      page: () => const VehicleRegistrationView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<VehicleRegistrationController>(
          () => VehicleRegistrationController(),
        );
      }),
    ),
    GetPage(
      name: Routes.importantNotice,
      page: () => const ImportantNoticeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ImportantNoticeController>(
          () => ImportantNoticeController(),
        );
      }),
    ),
  ];
}
