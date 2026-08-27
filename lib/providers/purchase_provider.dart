import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseIds {
  PurchaseIds._();
  static const String unlockAll = 'baraem_premium_unlock';
  static const Set<String> all = {unlockAll};
}

enum PurchaseUiState { idle, loading, purchasing, error }

class PurchaseProvider extends ChangeNotifier {
  // Keep plugin access lazy: constructing this provider during startup must
  // not touch the Android billing channel before the first frame.
  InAppPurchase? _iap;
  InAppPurchase get _store => _iap ??= InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool storeAvailable = false;
  List<ProductDetails> products = [];
  PurchaseUiState uiState = PurchaseUiState.idle;
  String? errorMessage;

  void Function(bool isPremium)? onPremiumChanged;

  Future<void> init() async {
    try {
      storeAvailable = await _store.isAvailable();
      if (!storeAvailable) {
        notifyListeners();
        return;
      }

      _subscription = _store.purchaseStream.listen(
        _handlePurchaseUpdates,
        onDone: () => _subscription?.cancel(),
        onError: (Object error) {
          uiState = PurchaseUiState.error;
          errorMessage = error.toString();
          notifyListeners();
        },
      );

      await _loadProducts();
    } catch (error) {
      storeAvailable = false;
      uiState = PurchaseUiState.error;
      errorMessage = error.toString();
      if (kDebugMode) {
        debugPrint('⚠️ Google Play Billing unavailable: $error');
      }
      notifyListeners();
    }
  }

  Future<void> _loadProducts() async {
    uiState = PurchaseUiState.loading;
    notifyListeners();

    final response = await _store.queryProductDetails(PurchaseIds.all);

    if (response.error != null) {
      uiState = PurchaseUiState.error;
      errorMessage = response.error!.message;
      notifyListeners();
      return;
    }
    if (response.notFoundIDs.isNotEmpty && kDebugMode) {
      debugPrint('⚠️ Produits introuvables sur le store: ${response.notFoundIDs}. '
          'Vérifie qu\'ils sont créés et actifs dans Play Console.');
    }

    products = response.productDetails;
    uiState = PurchaseUiState.idle;
    notifyListeners();
  }

  ProductDetails? get unlockAllProduct {
    for (final p in products) {
      if (p.id == PurchaseIds.unlockAll) return p;
    }
    return null;
  }

  Future<void> buyUnlockAll() async {
    final product = unlockAllProduct;
    if (product == null) return;

    uiState = PurchaseUiState.purchasing;
    errorMessage = null;
    notifyListeners();

    final param = PurchaseParam(productDetails: product);
    await _store.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() async {
    uiState = PurchaseUiState.purchasing;
    notifyListeners();
    await _store.restorePurchases();
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        uiState = PurchaseUiState.purchasing;
        notifyListeners();
      } else if (purchase.status == PurchaseStatus.error) {
        uiState = PurchaseUiState.error;
        errorMessage = purchase.error?.message;
        notifyListeners();
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (purchase.productID == PurchaseIds.unlockAll) {
          onPremiumChanged?.call(true);
        }
        uiState = PurchaseUiState.idle;
        notifyListeners();
      }

      if (purchase.pendingCompletePurchase) {
        await _store.completePurchase(purchase);
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
