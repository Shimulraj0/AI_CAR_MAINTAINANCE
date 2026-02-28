import 'package:get/get.dart';
import '../views/home/home_view.dart';
import '../views/home/analyzing_view.dart';
import '../views/home/diagnostic_result_view.dart';
import '../views/home/save_reports_view.dart';
import '../views/home/ai_chat_view.dart';
import '../views/home/task_details_view.dart';
import '../views/home/add_maintenance_view.dart';
import '../views/splash/splash_view.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/auth/login/login_view.dart';
import '../views/home/subscription_view.dart';
import '../views/home/edit_profile_view.dart';
import '../views/home/my_vehicles_view.dart';
import '../views/home/add_vehicles_view.dart';
import '../controllers/login_controller.dart';
import '../views/auth/signup/signup_view.dart';
import '../controllers/signup_controller.dart';
import '../views/auth/forgot_password/forgot_password_view.dart';
import '../controllers/forgot_password_controller.dart';
import '../views/auth/verify_email/verify_email_view.dart';
import '../controllers/verify_email_controller.dart';
import '../views/auth/change_password/change_password_view.dart';
import '../views/auth/change_password/password_reset_success_view.dart';
import '../controllers/change_password_controller.dart';
import '../views/vehicle_registration/vehicle_registration_view.dart';
import '../controllers/vehicle_registration_controller.dart';
import '../views/important_notice/important_notice_view.dart';
import '../controllers/important_notice_controller.dart';
import '../views/notifications/notifications_view.dart';
import '../controllers/notifications_controller.dart';
import '../views/privacy_terms/privacy_terms_view.dart';
import '../controllers/privacy_terms_controller.dart';
import '../views/privacy_terms/privacy_policy_view.dart';
import '../controllers/privacy_policy_controller.dart';
import '../views/privacy_terms/terms_conditions_view.dart';
import '../controllers/terms_conditions_controller.dart';
import '../views/faqs/faqs_view.dart';
import '../controllers/faqs_controller.dart';
import '../views/support/contact_support_view.dart';
import '../controllers/contact_support_controller.dart';
import '../controllers/diagnostic_result_controller.dart';
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
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      transition: Transition.noTransition,
    ),
    GetPage(name: Routes.onboarding, page: () => const OnboardingView()),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignUpView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
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
    GetPage(name: Routes.analyzing, page: () => const AnalyzingView()),
    GetPage(
      name: Routes.diagnosticResult,
      page: () => const DiagnosticResultView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DiagnosticResultController>(
          () => DiagnosticResultController(),
        );
      }),
    ),
    GetPage(name: Routes.saveReports, page: () => const SaveReportsView()),
    GetPage(name: Routes.aiChat, page: () => const AiChatView()),
    GetPage(name: Routes.taskDetails, page: () => const TaskDetailsView()),
    GetPage(
      name: Routes.addMaintenance,
      page: () => const AddMaintenanceView(),
    ),
    GetPage(name: Routes.subscription, page: () => const SubscriptionView()),
    GetPage(name: Routes.editProfile, page: () => const EditProfileView()),
    GetPage(name: Routes.myVehicles, page: () => const MyVehiclesView()),
    GetPage(name: Routes.addVehicles, page: () => const AddVehiclesView()),
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NotificationsController>(() => NotificationsController());
      }),
    ),
    GetPage(
      name: Routes.privacyTerms,
      page: () => const PrivacyTermsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PrivacyTermsController>(() => PrivacyTermsController());
      }),
    ),
    GetPage(
      name: Routes.privacyPolicy,
      page: () => const PrivacyPolicyView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PrivacyPolicyController>(() => PrivacyPolicyController());
      }),
    ),
    GetPage(
      name: Routes.termsConditions,
      page: () => const TermsConditionsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TermsConditionsController>(
          () => TermsConditionsController(),
        );
      }),
    ),
    GetPage(
      name: Routes.faqs,
      page: () => const FaqsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<FaqsController>(() => FaqsController());
      }),
    ),
    GetPage(
      name: Routes.contactSupport,
      page: () => const ContactSupportView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ContactSupportController>(() => ContactSupportController());
      }),
    ),
  ];
}
