import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/providers/auth_provider.dart';
import 'package:myapp/core/providers/vessel_provider.dart';
import 'package:myapp/core/repositories/vessel_repository.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/app_button.dart';
import 'package:myapp/shared/widgets/app_text_field.dart';

// File-scoped autoDispose providers — live only as long as this screen does.
final _addVesselTypeProvider =
    StateProvider.autoDispose<String>((_) => 'sailboat');
final _addVesselSavingProvider =
    StateProvider.autoDispose<bool>((_) => false);

/// Form screen for adding a new vessel to the user's profile.
///
/// On successful save: creates the vessel via repository, invalidates
/// [userVesselsProvider], pops the screen, and shows a success snackbar.
class AddVesselScreen extends ConsumerStatefulWidget {
  const AddVesselScreen({super.key});

  @override
  ConsumerState<AddVesselScreen> createState() => _AddVesselScreenState();
}

class _AddVesselScreenState extends ConsumerState<AddVesselScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _lenCtrl   = TextEditingController();
  final _draftCtrl = TextEditingController();
  final _beamCtrl  = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lenCtrl.dispose();
    _draftCtrl.dispose();
    _beamCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n     = AppLocalizations.of(context)!;
    final type     = ref.watch(_addVesselTypeProvider);
    final isSaving = ref.watch(_addVesselSavingProvider);

    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        title:           Text(l10n.addVesselTitle),
        backgroundColor: navyDeep,
        foregroundColor: Colors.white,
        elevation:       0,
        leading: IconButton(
          icon:      const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          children: [
            // ── Vessel name ───────────────────────────────────────────────
            AppTextField(
              label:      l10n.vesselName,
              controller: _nameCtrl,
              validator:  (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 16),

            // ── Vessel type ───────────────────────────────────────────────
            _TypeDropdown(
              label: l10n.vesselType,
              value: type,
              items: [
                ('sailboat',  l10n.vesselTypeSailboat),
                ('motorboat', l10n.vesselTypeMotorboat),
                ('catamaran', l10n.vesselTypeCatamaran),
                ('water_taxi', l10n.vesselTypeWaterTaxi),
                ('other',     l10n.vesselTypeOther),
              ],
              onChanged: (v) =>
                  ref.read(_addVesselTypeProvider.notifier).state = v,
            ),
            const SizedBox(height: 16),

            // ── Length (required) ─────────────────────────────────────────
            AppTextField(
              label:        l10n.vesselLength,
              controller:   _lenCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l10n.fieldRequired;
                if (double.tryParse(v.trim()) == null) return l10n.fieldRequired;
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Draft (optional) ──────────────────────────────────────────
            AppTextField(
              label:        l10n.vesselDraft,
              controller:   _draftCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),

            // ── Beam (optional) ───────────────────────────────────────────
            AppTextField(
              label:        l10n.vesselBeam,
              controller:   _beamCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 32),

            // ── Save button ───────────────────────────────────────────────
            AppButton(
              label:     l10n.saveVessel,
              isLoading: isSaving,
              onPressed: isSaving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final l10n = AppLocalizations.of(context)!;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    ref.read(_addVesselSavingProvider.notifier).state = true;
    try {
      await ref.read(vesselRepositoryProvider).createVessel(
        CreateVesselRequest(
          ownerId: user.id,
          name:    _nameCtrl.text.trim(),
          type:    ref.read(_addVesselTypeProvider),
          lengthM: double.parse(_lenCtrl.text.trim()),
          draftM:  _draftCtrl.text.trim().isNotEmpty
              ? double.tryParse(_draftCtrl.text.trim())
              : null,
          beamM: _beamCtrl.text.trim().isNotEmpty
              ? double.tryParse(_beamCtrl.text.trim())
              : null,
        ),
      );

      ref.invalidate(userVesselsProvider);

      if (!mounted) return;
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.vesselSavedSuccess,
            style: GoogleFonts.dmSans(color: Colors.white),
          ),
          backgroundColor: tealPrimary,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.errorNetwork,
            style: GoogleFonts.dmSans(color: Colors.white),
          ),
          backgroundColor: dangerRed,
        ),
      );
    } finally {
      if (mounted) {
        ref.read(_addVesselSavingProvider.notifier).state = false;
      }
    }
  }
}

// ── Type dropdown ──────────────────────────────────────────────────────────────

class _TypeDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<(String, String)> items;
  final ValueChanged<String> onChanged;

  const _TypeDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 13, fontWeight: FontWeight.w500, color: slateGrey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color:        offWhite,
            borderRadius: BorderRadius.circular(12),
            border:       Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<String>(
            value:        value,
            isExpanded:   true,
            underline:    const SizedBox.shrink(),
            style:        GoogleFonts.dmSans(fontSize: 15, color: navyDeep),
            dropdownColor: Colors.white,
            items: items
                .map((t) => DropdownMenuItem<String>(
                      value: t.$1,
                      child: Text(t.$2),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ],
    );
  }
}
