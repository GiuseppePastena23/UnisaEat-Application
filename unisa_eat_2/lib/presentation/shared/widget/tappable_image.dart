import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A tappable image card with optional text overlay using local assets
/// Static images that don't change - perfect for menu items
class TappableImageCard extends StatelessWidget {
  final String assetImagePath; // Path to your local image
  final String? overlayText; // Optional bold title text
  final String? subtitleText; // Optional smaller subtitle text
  final String routePath;
  final double borderRadius;
  final double height;
  final double width;
  final BoxFit imageFit;

  const TappableImageCard({
    Key? key,
    required this.assetImagePath,
    this.overlayText, // Made optional
    this.subtitleText, // Made optional
    required this.routePath,
    this.borderRadius = 20.0,
    this.height = 200.0,
    this.width = double.infinity,
    this.imageFit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(routePath),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              // Local asset image layer
              Image.asset(
                assetImagePath,
                fit: imageFit,
                width: width,
                height: height,
              ),
              // Semi-transparent overlay (darker at bottom)
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
              // Text at bottom-left (only if text is provided)
              if (overlayText != null || subtitleText != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bold title text
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
                      // Spacing between title and subtitle
                      if (overlayText != null && subtitleText != null)
                        const SizedBox(height: 4),
                      // Smaller, non-bold subtitle text
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
    );
  }
}
