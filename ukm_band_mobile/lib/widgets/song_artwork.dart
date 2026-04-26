import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SongArtwork extends StatelessWidget {
  final String source;
  final double size;
  final BorderRadius borderRadius;

  const SongArtwork({
    super.key,
    required this.source,
    required this.size,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
  });

  @override
  Widget build(BuildContext context) {
    final normalizedSource = source.endsWith('default-cover.jpg') ? '' : source;
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.cardSoft,
        borderRadius: borderRadius,
        border: Border.all(color: AppColors.line),
      ),
      child: const Icon(Icons.music_note_rounded, color: AppColors.muted),
    );

    Widget image;
    if (normalizedSource.startsWith('http://') ||
        normalizedSource.startsWith('https://')) {
      image = Image.network(
        normalizedSource,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    } else if (normalizedSource.isNotEmpty) {
      image = Image.asset(
        normalizedSource,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    } else {
      image = fallback;
    }

    return ClipRRect(borderRadius: borderRadius, child: image);
  }
}

class AppGlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  State<AppGlassCard> createState() => _AppGlassCardState();
}

class _AppGlassCardState extends State<AppGlassCard> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null || _isPressed == value) {
      return;
    }
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line.withValues(alpha: 0.82)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: widget.child,
    );

    if (widget.onTap == null) {
      return content;
    }

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(24),
          child: content,
        ),
      ),
    );
  }
}
