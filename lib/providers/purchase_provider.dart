import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// ID(s) à créer côté Play Console > Monétisation > Produits > Produits gérés.
/// Un seul produit non-consommable pour la V1 : débloque tout le contenu
/// marqué `isPremium` (histoires, adkar, scénarios adab).
class PurchaseIds {
  PurchaseIds._();
  static const String unlockAll = 'baraem_premium_unlock';
  static const Set<String> all = {unlockAll};
}

/// États UI du flow d'achat (distinct de `PurchaseStatus` du package
/// in_app_purchase, qui décrit le statut d'une transaction individuelle).
enum PurchaseUiState { idle, loading, purchasing, error }

class PurchaseProvider extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool storeAvailable = false;
  List<ProductDetails> products = [];
  PurchaseUiState uiState = PurchaseUiState.idle;
  String? errorMessage;

  /// Branché depuis main.dart sur ProgressProvider.setPremium.
  /// Découplage volontaire : ce provider ne connaît pas ProgressProvider.
  void Function(bool isPremium)? onPremiumChanged;

  Future<void> init() async {
    try {
      storeAvailable = await _iap.isAvailable();
      if (!storeAvailable) {
        notifyListeners();
        return;
      }

      _subscription = _iap.purchaseStream.listen(
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
      // Billing is optional at startup. A Play Store/device billing failure
      // must never prevent Baraem from reaching Home.
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

    final response = await _iap.queryProductDetails(PurchaseIds.all);

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
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() async {
    uiState = PurchaseUiState.purchasing;
    notifyListeners();
    await _iap.restorePurchases();
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
        // ⚠️ MVP : on débloque sur la base du statut local retourné par le
        // store. Pour la prod, valide idéalement purchase.verificationData
        // côté serveur (ex: Supabase Edge Function qui appelle l'API Google
        // Play Developer) avant de déclencher setPremium(true), pour éviter
        // le contournement par un achat falsifié.
        if (purchase.productID == PurchaseIds.unlockAll) {
          onPremiumChanged?.call(true);
        }
        uiState = PurchaseUiState.idle;
        notifyListeners();
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
