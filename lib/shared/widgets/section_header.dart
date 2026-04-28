import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/theme.dart';

/// A section divider with an ALL-CAPS label and an optional trailing action.
///
/// ```dart
/// SectionHeader(
///   label: l10n.myVessels,
///   action: TextButton(onPressed: ..., child: Text(l10n.addVessel)),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  final String label;

  /// Optional widget shown at the trailing edge, e.g. a "+ Add" button.
  final Widget? action;

  const SectionHeader({
    super.key,
    required this.label,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: slateGrey,
            letterSpacing: 1.0,
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}
