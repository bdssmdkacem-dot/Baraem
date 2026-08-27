import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/purchase_provider.dart';
import '../theme/app_colors.dart';

/// Bottom sheet d'achat réutilisée partout où l'enfant/parent touche un
/// contenu verrouillé (histoires, adkar, scénarios adab).
class PremiumSheet extends StatelessWidget {
  const PremiumSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const PremiumSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final purchase = context.watch<PurchaseProvider>();
    final product = purchase.unlockAllProduct;
    final isBusy = purchase.uiState == PurchaseUiState.loading ||
        purchase.uiState == PurchaseUiState.purchasing;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 28,
          bottom: MediaQuery.of(context).viewInsets.bottom + 28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryGold, size: 48),
            const SizedBox(height: 12),
            const Text(
              'افتح كل المحتوى المميز ✨',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'كل القصص، كل الأذكار، وكل السيناريوهات — بدون إعلانات',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 22),
            _buildBody(context, purchase, product, isBusy),
            const SizedBox(height: 6),
            TextButton(
              onPressed: isBusy ? null : () => purchase.restorePurchases(),
              child: const Text('استعادة المشتريات السابقة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PurchaseProvider purchase,
    dynamic product,
    bool isBusy,
  ) {
    if (!purchase.storeAvailable) {
      return const Text(
        'المتجر غير متاح حاليًا، حاول لاحقًا 🙏',
        style: TextStyle(color: AppColors.textMuted),
        textAlign: TextAlign.center,
      );
    }

    if (purchase.uiState == PurchaseUiState.error) {
      return Column(
        children: [
          Text(
            purchase.errorMessage ?? 'حدث خطأ، حاول مرة أخرى',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => purchase.buyUnlockAll(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      );
    }

    if (product == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isBusy ? null : () => purchase.buyUnlockAll(),
        child: isBusy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text('فتح كل المحتوى — ${product.price}'),
      ),
    );
  }
}
