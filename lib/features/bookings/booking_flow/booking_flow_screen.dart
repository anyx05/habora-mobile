import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/features/bookings/booking_flow/booking_flow_controller.dart';
import 'package:myapp/features/bookings/booking_flow/step1_vessel.dart';
import 'package:myapp/features/bookings/booking_flow/step2_contact.dart';
import 'package:myapp/features/bookings/booking_flow/step3_confirm.dart';
import 'package:myapp/l10n/app_localizations.dart';

/// Full-screen multi-step booking flow. Steps are animated in-place — no
/// new routes are pushed for each step.
class BookingFlowScreen extends ConsumerStatefulWidget {
  final String berthId;
  final String portId;
  final String berthName;
  final String portName;
  final double berthPricePerNight;
  final DateTime? arrivalDate;
  final DateTime? departureDate;

  const BookingFlowScreen({
    super.key,
    required this.berthId,
    required this.portId,
    this.berthName          = '',
    this.portName           = '',
    this.berthPricePerNight = 0,
    this.arrivalDate,
    this.departureDate,
  });

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeBookingFlowProvider.notifier).init(
        berthId:            widget.berthId,
        portId:             widget.portId,
        berthName:          widget.berthName,
        portName:           widget.portName,
        berthPricePerNight: widget.berthPricePerNight,
        arrivalDate:        widget.arrivalDate,
        departureDate:      widget.departureDate,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final step = ref.watch(
      activeBookingFlowProvider.select((s) => s.currentStep),
    );

    return PopScope(
      canPop: step == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          ref.read(activeBookingFlowProvider.notifier).goBack();
        }
      },
      child: Scaffold(
        backgroundColor: offWhite,
        appBar: AppBar(
          backgroundColor: navyDeep,
          foregroundColor: Colors.white,
          elevation:       0,
          title:           Text(_titleForStep(step, l10n)),
          leading: IconButton(
            icon:      const Icon(Icons.arrow_back),
            onPressed: () {
              if (step > 1) {
                ref.read(activeBookingFlowProvider.notifier).goBack();
              } else {
                context.pop();
              }
            },
          ),
          bottom: _StepIndicator(currentStep: step),
        ),
        body: AnimatedSwitcher(
          duration:        const Duration(milliseconds: 280),
          switchInCurve:   Curves.easeOut,
          switchOutCurve:  Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child:   SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end:   Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: switch (step) {
            2 => const Step2Contact(key: ValueKey(2)),
            3 => const Step3Confirm(key: ValueKey(3)),
            _ => const Step1Vessel(key: ValueKey(1)),
          },
        ),
      ),
    );
  }

  String _titleForStep(int step, AppLocalizations l10n) => switch (step) {
        2 => l10n.contactInfo,
        3 => l10n.confirmAction,
        _ => l10n.vesselDetails,
      };
}

// ── Step indicator (thin progress bar under AppBar) ────────────────────────────

class _StepIndicator extends StatelessWidget implements PreferredSizeWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Size get preferredSize => const Size.fromHeight(4);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      child: Row(
        children: List.generate(3, (i) {
          final filled = i < currentStep;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 2 ? 2 : 0),
              color: filled ? tealPrimary : Colors.white.withValues(alpha: 0.25),
            ),
          );
        }),
      ),
    );
  }
}

