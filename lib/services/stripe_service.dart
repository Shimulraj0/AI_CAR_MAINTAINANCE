import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import '../configs/stripe_config.dart';

class StripeService extends GetxService {
  Future<StripeService> init() async {
    Stripe.publishableKey = StripeConfig.publishableKey;
    Stripe.merchantIdentifier = StripeConfig.merchantIdentifier;
    await Stripe.instance.applySettings();
    return this;
  }

  Future<bool> makePayment({
    required String paymentIntentClientSecret,
    String? customerId,
    String? customerEphemeralKeySecret,
  }) async {
    try {
      // 1. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'AutoIntel',
          customerId: customerId,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
          style: ThemeMode.light,
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'GB',
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'GB',
            testEnv: true,
          ),
        ),
      );

      // 2. Display Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      return true;
    } on StripeException catch (e) {
      debugPrint('Stripe Error: ${e.error.localizedMessage}');
      return false;
    } catch (e) {
      debugPrint('General Payment Error: $e');
      return false;
    }
  }
}
