import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A tappable image card with optional text overlay using local assets
/// Static images that don't change - perfect for menu items
class TappableImageCard extends StatelessWidget {
  final String assetImagePath;
  final String? overlayText;
  final String? subtitleText;
  final String routePath;
  final double borderRadius;
  final double height;
  final double width;
  final BoxFit imageFit;
  final double elevation;

  const TappableImageCard({
    super.key,
    required this.assetImagePath,
    this.overlayText,
    this.subtitleText,
    required this.routePath,
    this.borderRadius = 20.0,
    this.height = 200.0,
    this.width = double.infinity,
    this.imageFit = BoxFit.cover,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      shadowColor: Colors.black26,
      child: GestureDetector(
        onTap: () => context.go(routePath),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              children: [
                Image.asset(
                  assetImagePath,
                  fit: imageFit,
                  width: width,
                  height: height,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                if (overlayText != null || subtitleText != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (overlayText != null)
                          Text(
                            overlayText!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (overlayText != null && subtitleText != null)
                          const SizedBox(height: 4),
                        if (subtitleText != null)
                          Text(
                            subtitleText!,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
