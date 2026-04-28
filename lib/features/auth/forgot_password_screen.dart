import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app/theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';

/// Forgot password screen — /auth/forgot-password.
///
/// Shows an email field that, on submit, calls [AuthNotifier.sendPasswordResetEmail].
/// On success the form is replaced by an inline confirmation state.
class ForgotPasswordScreen extends HookConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final emailCtrl = useTextEditingController();
    final isLoading = useState(false);
    final isSent = useState(false);
    final error = useState<String?>(null);
    final formKey = useMemoized(GlobalKey<FormState>.new);

    Future<void> submit() async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      isLoading.value = true;
      error.value = null;
      try {
        await ref
            .read(authProvider.notifier)
            .sendPasswordResetEmail(emailCtrl.text.trim());
        isSent.value = true;
      } catch (_) {
        error.value = l10n.errorNetwork;
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.forgotPassword),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isSent.value
                ? _SentConfirmation(key: const ValueKey('sent'), l10n: l10n)
                : _ResetForm(
                    key: const ValueKey('form'),
                    formKey: formKey,
                    emailCtrl: emailCtrl,
                    isLoading: isLoading.value,
                    error: error.value,
                    onSubmit: submit,
                    l10n: l10n,
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── Reset form ───────────────────────────────────────────────────────────────

class _ResetForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final bool isLoading;
  final String? error;
  final VoidCallback onSubmit;
  final AppLocalizations l10n;

  const _ResetForm({
    super.key,
    required this.formKey,
    required this.emailCtrl,
    required this.isLoading,
    required this.error,
    required this.onSubmit,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.forgotPassword,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          AppTextField(
            label: l10n.email,
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.mail_outline,
            enabled: !isLoading,
            textInputAction: TextInputAction.done,
            onEditingComplete: onSubmit,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l10n.fieldRequired;
              if (!v.contains('@')) return l10n.invalidEmail;
              return null;
            },
          ),
          if (error != null) ...[
            const SizedBox(height: 14),
            _ErrorBanner(message: error!),
          ],
          const SizedBox(height: 24),
          AppButton(
            label: l10n.sendResetLink,
            isLoading: isLoading,
            onPressed: isLoading ? null : onSubmit,
          ),
        ],
      ),
    );
  }
}

// ─── Sent confirmation ────────────────────────────────────────────────────────

class _SentConfirmation extends StatelessWidget {
  final AppLocalizations l10n;
  const _SentConfirmation({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: tealPale,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            color: tealPrimary,
            size: 36,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.checkEmail,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          l10n.resetEmailSentBody,
          style: const TextStyle(color: slateGrey, fontSize: 14, height: 1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── Error banner ─────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: dangerRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: dangerRed.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 16, color: dangerRed),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: dangerRed, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
