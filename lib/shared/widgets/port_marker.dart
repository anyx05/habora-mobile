import 'package:flutter/material.dart';
import 'package:myapp/shared/widgets/port_availability.dart';

/// A map marker for a port, colour-coded by berth availability.
///
/// Renders an inner solid circle with an anchor icon surrounded by a pulsing
/// translucent ring. Intended for use inside a [flutter_map] MarkerLayer.
///
/// The outer ring pulses its opacity between 0.15 and 0.30 on a loop to draw
/// attention without obscuring the map underneath.
class PortMarker extends StatefulWidget {
  final PortAvailability availability;
  final VoidCallback onTap;

  const PortMarker({
    super.key,
    required this.availability,
    required this.onTap,
  });

  @override
  State<PortMarker> createState() => _PortMarkerState();
}

class _PortMarkerState extends State<PortMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.15, end: 0.30).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = availabilityColor(widget.availability);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulsing ring
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: _pulse.value),
                ),
              ),
              // Inner solid marker
              child!,
            ],
          );
        },
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: availabilityColor(widget.availability),
            boxShadow: [
              BoxShadow(
                color: availabilityColor(widget.availability)
                    .withValues(alpha: 0.40),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.anchor,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
