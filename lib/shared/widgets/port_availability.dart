import 'package:flutter/material.dart';
import 'package:myapp/app/theme.dart';

/// Availability state for a port or berth, used by markers, badges, and list rows.
enum PortAvailability { available, limited, full }

/// Returns the brand colour associated with [availability].
Color availabilityColor(PortAvailability availability) {
  return switch (availability) {
    PortAvailability.available => tealPrimary,
    PortAvailability.limited   => amber,
    PortAvailability.full      => dangerRed,
  };
}

/// Derives [PortAvailability] from a raw berth count.
///
/// null → [PortAvailability.available] (optimistic default)
/// 0   → [PortAvailability.full]
/// 1–2 → [PortAvailability.limited]
/// 3+  → [PortAvailability.available]
PortAvailability availabilityFromCount(int? count) {
  if (count == null || count >= 3) return PortAvailability.available;
  if (count == 0) return PortAvailability.full;
  return PortAvailability.limited;
}
