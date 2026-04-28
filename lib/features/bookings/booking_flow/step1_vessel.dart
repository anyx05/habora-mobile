import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/models/vessel.dart';
import 'package:myapp/core/providers/vessel_provider.dart';
import 'package:myapp/features/bookings/booking_flow/booking_flow_controller.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/app_button.dart';
import 'package:myapp/shared/widgets/app_text_field.dart';
import 'package:myapp/shared/widgets/loading_shimmer.dart';
import 'package:myapp/shared/widgets/vessel_card.dart';

/// Step 1 of the booking flow — vessel selection or manual entry.
class Step1Vessel extends ConsumerStatefulWidget {
  const Step1Vessel({super.key});

  @override
  ConsumerState<Step1Vessel> createState() => _Step1VesselState();
}

class _Step1VesselState extends ConsumerState<Step1Vessel> {
  bool _manualEntry = false;
  final _formKey    = GlobalKey<FormState>();
  final _nameCtrl   = TextEditingController();
  final _lengthCtrl = TextEditingController();
  final _draftCtrl  = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lengthCtrl.dispose();
    _draftCtrl.dispose();
    super.dispose();
  }

  void _useVessel(Vessel vessel) {
    ref.read(activeBookingFlowProvider.notifier).selectVessel(vessel);
  }

  void _submitManual() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(activeBookingFlowProvider.notifier).setManualVessel(
      name:     _nameCtrl.text.trim(),
      lengthM:  double.parse(_lengthCtrl.text.trim()),
      draftM:   _draftCtrl.text.trim().isNotEmpty
          ? double.tryParse(_draftCtrl.text.trim())
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n        = AppLocalizations.of(context)!;
    final vesselsAsync = ref.watch(userVesselsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_manualEntry) ...[
              // ── Saved vessel selector ────────────────────────────────────
              vesselsAsync.when(
                loading: () => Column(
                  children: List.generate(
                    2,
                    (_) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LoadingShimmer(height: 80, borderRadius: radiusCard),
                    ),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
                data: (vessels) {
                  if (vessels.isEmpty) return const SizedBox.shrink();
                  return Column(
                    children: vessels
                        .map((v) => _VesselOption(
                              vessel:   v,
                              onSelect: () => _useVessel(v),
                              l10n:     l10n,
                            ))
                        .toList(),
                  );
                },
              ),

              // ── Enter manually link ──────────────────────────────────────
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _manualEntry = true),
                  child: Text(
                    l10n.enterManually,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: tealPrimary,
                    ),
                  ),
                ),
              ),
            ] else ...[
              // ── Manual entry form ────────────────────────────────────────
              AppTextField(
                label:    l10n.vesselName,
                controller: _nameCtrl,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label:    l10n.vesselLength,
                      controller: _lengthCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v?.trim().isEmpty ?? true) return l10n.fieldRequired;
                        if (double.tryParse(v!.trim()) == null) return l10n.fieldRequired;
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      label: l10n.vesselDraft,
                      controller: _draftCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.done,
                      onEditingComplete: _submitManual,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AppButton(label: l10n.continueAction, onPressed: _submitManual),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _manualEntry = false),
                  child: Text(
                    l10n.backAction,
                    style: GoogleFonts.dmSans(fontSize: 14, color: slateGrey),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VesselOption extends StatelessWidget {
  final Vessel vessel;
  final VoidCallback onSelect;
  final AppLocalizations l10n;

  const _VesselOption({
    required this.vessel,
    required this.onSelect,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          VesselCard(vessel: vessel, onTap: onSelect),
          const SizedBox(height: 8),
          AppButton(
            label:      l10n.useThisVessel,
            onPressed:  onSelect,
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}
