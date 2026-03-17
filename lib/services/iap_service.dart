import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Product IDs — must match exactly what you configure in App Store Connect / Google Play.
class IAPProductIds {
  static const String proMonthly = 'autointel_pro_monthly';
  static const String reportUnlock = 'autointel_report_unlock';
  static const Set<String> all = {proMonthly, reportUnlock};
}

class IAPService extends GetxService {
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  // Observable states
  final RxBool isAvailable = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final Rx<PurchaseStatus?> lastPurchaseStatus = Rx<PurchaseStatus?>(null);

  // Callback triggered on a successful purchase
  VoidCallback? onPurchaseSuccess;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initialize();
  }

  Future<void> _initialize() async {
    isAvailable.value = await _iap.isAvailable();
    if (!isAvailable.value) {
      debugPrint('[IAP] Store not available on this device.');
      return;
    }

    // Listen to the purchase update stream
    _purchaseSubscription = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onError: (error) => debugPrint('[IAP] Purchase stream error: $error'),
    );

    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    isLoading.value = true;
    try {
      final response = await _iap.queryProductDetails(IAPProductIds.all);
      if (response.error != null) {
        debugPrint('[IAP] Product query error: ${response.error}');
      }
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('[IAP] Product IDs not found: ${response.notFoundIDs}');
      }
      products.assignAll(response.productDetails);
      debugPrint('[IAP] Loaded ${products.length} product(s).');
    } catch (e) {
      debugPrint('[IAP] Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Purchase any product by ID.
  /// In debug mode with no store available, simulates a successful purchase.
  Future<bool> buyProduct(String productId) async {
    // ── DEBUG / DUMMY MODE ─────────────────────────────────────────────────────
    if (kDebugMode && !isAvailable.value) {
      debugPrint('[IAP] 🧪 Debug mode: simulating purchase of $productId');
      await Future.delayed(const Duration(milliseconds: 1500));
      onPurchaseSuccess?.call();
      return true;
    }
    // ── END DEBUG MODE ─────────────────────────────────────────────────────────

    if (!isAvailable.value) {
      Get.snackbar('Unavailable', 'In-App Purchases are not available on this device.');
      return false;
    }

    final ProductDetails? product = products.firstWhereOrNull(
      (p) => p.id == productId,
    );

    if (product == null) {
      Get.snackbar('Error', 'Product not found. Please try again later.');
      debugPrint('[IAP] Product "$productId" not found in product list.');
      return false;
    }

    final purchaseParam = PurchaseParam(productDetails: product);
    try {
      // Use buyNonConsumable for subscriptions; buyConsumable for one-time unlocks
      if (productId == IAPProductIds.proMonthly) {
        return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        return await _iap.buyConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      debugPrint('[IAP] Error triggering purchase: $e');
      Get.snackbar('Error', 'Failed to start purchase. Please try again.');
      return false;
    }
  }

  /// Restore previous purchases (required for App Store compliance)
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      debugPrint('[IAP] Purchase update: ${purchase.productID} status=${purchase.status}');

      if (purchase.status == PurchaseStatus.pending) {
        // Show loading while payment processes
        isLoading.value = true;
      } else {
        isLoading.value = false;

        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          // ✅ Deliver the product
          _deliverProduct(purchase);
        } else if (purchase.status == PurchaseStatus.error) {
          debugPrint('[IAP] Purchase error: ${purchase.error?.message}');
          Get.snackbar(
            'Payment Failed',
            purchase.error?.message ?? 'An error occurred during payment.',
          );
        } else if (purchase.status == PurchaseStatus.canceled) {
          Get.snackbar('Cancelled', 'Purchase was cancelled.');
        }

        // Complete the purchase to finalise the transaction
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }

      lastPurchaseStatus.value = purchase.status;
    }
  }

  void _deliverProduct(PurchaseDetails purchase) {
    debugPrint('[IAP] Delivering product: ${purchase.productID}');
    // Trigger the success callback (set by HomeController)
    onPurchaseSuccess?.call();
  }

  @override
  void onClose() {
    _purchaseSubscription?.cancel();
    super.onClose();
  }
}
