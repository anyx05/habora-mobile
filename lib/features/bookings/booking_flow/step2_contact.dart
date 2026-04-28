import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/providers/auth_provider.dart';
import 'package:myapp/features/bookings/booking_flow/booking_flow_controller.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/app_button.dart';
import 'package:myapp/shared/widgets/app_text_field.dart';

/// Step 2 of the booking flow — contact info with optional pre-fill.
class Step2Contact extends ConsumerStatefulWidget {
  const Step2Contact({super.key});

  @override
  ConsumerState<Step2Contact> createState() => _Step2ContactState();
}

class _Step2ContactState extends ConsumerState<Step2Contact> {
  final _formKey    = GlobalKey<FormState>();
  final _nameCtrl   = TextEditingController();
  final _emailCtrl  = TextEditingController();
  final _notesCtrl  = TextEditingController();
  bool _editing     = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill from logged-in user if available
    final user      = ref.read(currentUserProvider);
    final flowState = ref.read(activeBookingFlowProvider);

    if (flowState.customerName != null)  _nameCtrl.text  = flowState.customerName!;
    if (flowState.customerEmail != null) _emailCtrl.text = flowState.customerEmail!;
    if (flowState.notes != null)         _notesCtrl.text = flowState.notes!;

    // If not already set from flow state, try from auth user
    if (_nameCtrl.text.isEmpty && user != null) {
      _nameCtrl.text  = (user.userMetadata?['full_name'] as String?) ?? '';
    }
    if (_emailCtrl.text.isEmpty && user?.email != null) {
      _emailCtrl.text = user!.email!;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(activeBookingFlowProvider.notifier).setContactInfo(
      name:  _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n       = AppLocalizations.of(context)!;
    final user       = ref.watch(currentUserProvider);
    final isLoggedIn = user != null;
    final readOnly   = isLoggedIn && !_editing;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label:           l10n.fullName,
              controller:      _nameCtrl,
              enabled:         !readOnly,
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label:           l10n.email,
              controller:      _emailCtrl,
              keyboardType:    TextInputType.emailAddress,
              enabled:         !readOnly,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v?.trim().isEmpty ?? true) return l10n.fieldRequired;
                if (!(v!.trim().contains('@') && v.trim().contains('.'))) {
                  return l10n.invalidEmail;
                }
                return null;
              },
            ),

            // Toggle read-only for pre-filled fields
            if (isLoggedIn) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _editing = !_editing),
                  child: Text(
                    _editing ? l10n.confirmAction : l10n.editAction,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: tealPrimary,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),
            AppTextField(
              label:      l10n.notesLabel,
              hint:       l10n.notesHint,
              controller: _notesCtrl,
              textInputAction: TextInputAction.done,
              onEditingComplete: _continue,
            ),
            const SizedBox(height: 32),
            AppButton(label: l10n.continueAction, onPressed: _continue),
          ],
        ),
      ),
    );
  }
}
