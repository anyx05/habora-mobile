import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/theme.dart';

/// Visual variant for [AppButton].
enum AppButtonVariant {
  /// Teal fill, white text — primary call to action.
  primary,

  /// White fill, navy border, navy text — secondary action.
  ghost,

  /// Red fill, white text — destructive action.
  danger,
}

/// A full-width (or shrink-wrapped) button with three visual variants,
/// a loading state, and an optional leading icon.
///
/// Set [isLoading] to replace the label with a spinner and disable taps.
/// Set [shrinkWrap] to let the button size to its content instead of
/// stretching to the full available width.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool shrinkWrap;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.shrinkWrap = false,
  });

  Color get _bg => switch (variant) {
        AppButtonVariant.primary => tealPrimary,
        AppButtonVariant.ghost   => Colors.white,
        AppButtonVariant.danger  => dangerRed,
      };

  Color get _fg => switch (variant) {
        AppButtonVariant.primary => Colors.white,
        AppButtonVariant.ghost   => navyDeep,
        AppButtonVariant.danger  => Colors.white,
      };

  @override
  Widget build(BuildContext context) {
    final content = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_fg),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: _fg),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _fg,
                ),
              ),
            ],
          );

    final style = ElevatedButton.styleFrom(
      backgroundColor: _bg,
      foregroundColor: _fg,
      disabledBackgroundColor: _bg.withValues(alpha: 0.55),
      disabledForegroundColor: _fg.withValues(alpha: 0.55),
      elevation: variant == AppButtonVariant.ghost ? 0 : 3,
      shadowColor: variant == AppButtonVariant.ghost
          ? Colors.transparent
          : _bg.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusButton),
        side: variant == AppButtonVariant.ghost
            ? const BorderSide(color: navyDeep, width: 1.5)
            : BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    );

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: content,
    );

    if (shrinkWrap) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
