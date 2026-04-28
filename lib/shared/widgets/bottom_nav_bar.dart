import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/l10n/app_localizations.dart';

/// Custom bottom navigation bar for the three main app tabs.
///
/// Tabs: Ports, Bookings, Me.
///
/// The active tab renders its icon and label in [tealPrimary] plus a small teal
/// dot beneath the label. Inactive tabs use [slateLight]. A top border in
/// [borderColor] separates the bar from the screen content. The bar is padded
/// for the system home indicator via [SafeArea].
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final items = [
      _NavItem(icon: Icons.map_outlined,            label: l10n?.portsTabLabel    ?? 'Ports'),
      _NavItem(icon: Icons.calendar_today_outlined, label: l10n?.bookingsTabLabel ?? 'Bookings'),
      _NavItem(icon: Icons.person_outline,          label: l10n?.meTabLabel       ?? 'Me'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: List.generate(items.length, (index) {
              final active = index == currentIndex;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: _NavItemWidget(item: items[index], active: active),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ── Private helpers ──────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _NavItemWidget extends StatelessWidget {
  final _NavItem item;
  final bool active;

  const _NavItemWidget({required this.item, required this.active});

  @override
  Widget build(BuildContext context) {
    final color = active ? tealPrimary : slateLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(item.icon, size: 24, color: color),
        const SizedBox(height: 3),
        Text(
          item.label,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        // Active indicator dot
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: active ? 5 : 0,
          height: active ? 5 : 0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: tealPrimary,
          ),
        ),
      ],
    );
  }
}
