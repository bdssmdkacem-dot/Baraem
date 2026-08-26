import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

class MascotWidget extends StatelessWidget {
  final String message;
  final String? imageAsset;
  final double size;

  const MascotWidget({super.key, required this.message, this.imageAsset, this.size = 84});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: AppColors.mascotGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: imageAsset != null
              ? ClipOval(child: SvgPicture.asset(imageAsset!, fit: BoxFit.cover, placeholderBuilder: (_) => const Icon(Icons.pets, color: Colors.white, size: 40)))
              : const Icon(Icons.pets, color: Colors.white, size: 40),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: Text(message, textAlign: TextAlign.right, textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark, height: 1.4)),
          ),
        ),
      ],
    );
  }
}
