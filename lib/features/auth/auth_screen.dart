import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';

/// Login / sign-up screen.  Both /auth/login and /auth/signup resolve here;
/// [initialSignUp] controls which tab is pre-selected.
class AuthScreen extends HookConsumerWidget {
  final bool initialSignUp;
  const AuthScreen({super.key, this.initialSignUp = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isSignUp = useState(initialSignUp);
    final isLoading = useState(false);
    final error = useState<String?>(null);
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final nameCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();
    final confirmCtrl = useTextEditingController();

    final returnTo =
        GoRouterState.of(context).uri.queryParameters['returnTo'];

    void onSuccess() {
      if (returnTo != null && returnTo.isNotEmpty) {
        context.go(Uri.decodeComponent(returnTo));
      } else {
        context.go(Routes.ports);
      }
    }

    String mapError(Object e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('invalid login credentials')) {
        return l10n.errorInvalidCredentials;
      }
      if (msg.contains('user already registered')) {
        return l10n.errorUserExists;
      }
      return l10n.errorNetwork;
    }

    void showRoleMismatchDialog() {
      if (!context.mounted) return;
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            l10n.wrongAccountTitle,
            style: const TextStyle(
              color: navyDeep,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          content: Text(
            l10n.wrongAccountMessage,
            style: const TextStyle(color: slateGrey, fontSize: 14, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.ok,
                style: const TextStyle(
                  color: tealPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Future<void> submit() async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      isLoading.value = true;
      error.value = null;
      try {
        if (isSignUp.value) {
          final email = emailCtrl.text.trim();
          await ref.read(authProvider.notifier).signUpWithEmail(
                email: email,
                password: passwordCtrl.text,
                fullName: nameCtrl.text.trim(),
              );
          if (context.mounted) {
            context.goNamed(
              'signupConfirmation',
              queryParameters: {'email': email},
            );
          }
          return;
        }
        await ref.read(authProvider.notifier).signInWithEmail(
              emailCtrl.text.trim(),
              passwordCtrl.text,
            );
        onSuccess();
      } on AuthException catch (e) {
        if (!context.mounted) return;
        if (e.statusCode == 'ROLE_MISMATCH') {
          showRoleMismatchDialog();
        } else {
          error.value = mapError(e);
        }
      } catch (e) {
        if (context.mounted) error.value = mapError(e);
      } finally {
        if (context.mounted) isLoading.value = false;
      }
    }

    Future<void> signInWithGoogle() async {
      isLoading.value = true;
      error.value = null;
      try {
        await ref.read(authProvider.notifier).signInWithGoogle();
        if (context.mounted) onSuccess();
      } on AuthException catch (e) {
        if (!context.mounted) return;
        if (e.statusCode == 'ROLE_MISMATCH') {
          showRoleMismatchDialog();
        } else {
          error.value = mapError(e);
        }
      } catch (e) {
        if (context.mounted) error.value = mapError(e);
      } finally {
        if (context.mounted) isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: navyDeep,
      body: Column(
        children: [
          _HeroSection(l10n: l10n),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radiusBottomSheet),
                  topRight: Radius.circular(radiusBottomSheet),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AuthModeToggle(
                        isSignUp: isSignUp.value,
                        onToggle: (v) {
                          isSignUp.value = v;
                          error.value = null;
                          formKey.currentState?.reset();
                        },
                        l10n: l10n,
                      ),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: isSignUp.value
                            ? _SignUpForm(
                                key: const ValueKey('signup'),
                                nameCtrl: nameCtrl,
                                emailCtrl: emailCtrl,
                                passwordCtrl: passwordCtrl,
                                confirmCtrl: confirmCtrl,
                                isLoading: isLoading.value,
                                onSubmit: submit,
                                l10n: l10n,
                              )
                            : _SignInForm(
                                key: const ValueKey('signin'),
                                emailCtrl: emailCtrl,
                                passwordCtrl: passwordCtrl,
                                isLoading: isLoading.value,
                                onSubmit: submit,
                                l10n: l10n,
                              ),
                      ),
                      if (error.value != null) ...[
                        const SizedBox(height: 14),
                        _ErrorBanner(message: error.value!),
                      ],
                      const SizedBox(height: 20),
                      _OrDivider(label: l10n.orDivider),
                      const SizedBox(height: 16),
                      AppButton(
                        label: l10n.continueWithGoogle,
                        variant: AppButtonVariant.ghost,
                        icon: Icons.g_mobiledata,
                        isLoading: isLoading.value,
                        onPressed: isLoading.value ? null : signInWithGoogle,
                      ),
                      const SizedBox(height: 24),
                      _AuthFooter(
                        isSignUp: isSignUp.value,
                        l10n: l10n,
                        onToggle: () {
                          isSignUp.value = !isSignUp.value;
                          error.value = null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero ────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _HeroSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _NauticalChartPainter()),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Logo row
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: tealPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text('⚓', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    l10n.tagline,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.taglineSub,
                    style: const TextStyle(
                      color: Color(0xCCFFFFFF),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NauticalChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = navyLight
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    // Latitude / longitude grid
    const cols = 10;
    const rows = 7;
    for (var i = 0; i <= cols; i++) {
      final x = size.width * i / cols;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var i = 0; i <= rows; i++) {
      final y = size.height * i / rows;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Diagonal depth-contour arc
    final arcPaint = Paint()
      ..color = navyLight
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.1, size.height * 1.1),
        width: size.width * 1.1,
        height: size.height * 1.4,
      ),
      -math.pi * 0.55,
      math.pi * 0.4,
      false,
      arcPaint,
    );

    // Island blobs
    final islandFill = Paint()
      ..color = const Color(0xFF1A3050)
      ..style = PaintingStyle.fill;
    final islandStroke = Paint()
      ..color = const Color(0xFF1F3B62)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    void drawIsland(double cx, double cy, double w, double h) {
      final r = Rect.fromCenter(
        center: Offset(size.width * cx, size.height * cy),
        width: w,
        height: h,
      );
      canvas.drawOval(r, islandFill);
      canvas.drawOval(r, islandStroke);
    }

    drawIsland(0.18, 0.44, 50, 22);
    drawIsland(0.62, 0.66, 62, 27);
    drawIsland(0.83, 0.27, 36, 16);
    drawIsland(0.44, 0.18, 28, 13);

    // Glowing port markers
    void drawMarker(double cx, double cy) {
      final center = Offset(size.width * cx, size.height * cy);

      canvas.drawCircle(
        center, 24,
        Paint()
          ..color = tealPrimary.withValues(alpha: 0.07)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        center, 15,
        Paint()
          ..color = tealPrimary.withValues(alpha: 0.14)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        center, 8,
        Paint()
          ..color = tealPrimary.withValues(alpha: 0.30)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        center, 4,
        Paint()
          ..color = tealPrimary
          ..style = PaintingStyle.fill,
      );
    }

    drawMarker(0.34, 0.56);
    drawMarker(0.72, 0.37);
    drawMarker(0.14, 0.73);
  }

  @override
  bool shouldRepaint(_NauticalChartPainter old) => false;
}

// ─── Toggle ──────────────────────────────────────────────────────────────────

class _AuthModeToggle extends StatelessWidget {
  final bool isSignUp;
  final ValueChanged<bool> onToggle;
  final AppLocalizations l10n;

  const _AuthModeToggle({
    required this.isSignUp,
    required this.onToggle,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: offWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          _ToggleTab(
            label: l10n.signIn,
            isActive: !isSignUp,
            onTap: () => onToggle(false),
          ),
          _ToggleTab(
            label: l10n.createAccount,
            isActive: isSignUp,
            onTap: () => onToggle(true),
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? navyDeep : slateGrey,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Forms ───────────────────────────────────────────────────────────────────

class _SignInForm extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final bool isLoading;
  final VoidCallback onSubmit;
  final AppLocalizations l10n;

  const _SignInForm({
    super.key,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.isLoading,
    required this.onSubmit,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: l10n.email,
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.mail_outline,
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return l10n.fieldRequired;
            if (!v.contains('@')) return l10n.invalidEmail;
            return null;
          },
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: l10n.password,
          controller: passwordCtrl,
          obscureText: true,
          prefixIcon: Icons.lock_outline,
          enabled: !isLoading,
          textInputAction: TextInputAction.done,
          onEditingComplete: onSubmit,
          validator: (v) {
            if (v == null || v.isEmpty) return l10n.fieldRequired;
            return null;
          },
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => context.pushNamed('forgotPassword'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                l10n.forgotPassword,
                style: const TextStyle(
                  color: tealPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: l10n.signIn,
          isLoading: isLoading,
          onPressed: isLoading ? null : onSubmit,
        ),
      ],
    );
  }
}

class _SignUpForm extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmCtrl;
  final bool isLoading;
  final VoidCallback onSubmit;
  final AppLocalizations l10n;

  const _SignUpForm({
    super.key,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.confirmCtrl,
    required this.isLoading,
    required this.onSubmit,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: l10n.fullName,
          controller: nameCtrl,
          prefixIcon: Icons.person_outline,
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return l10n.fieldRequired;
            return null;
          },
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: l10n.email,
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.mail_outline,
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return l10n.fieldRequired;
            if (!v.contains('@')) return l10n.invalidEmail;
            return null;
          },
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: l10n.password,
          controller: passwordCtrl,
          obscureText: true,
          prefixIcon: Icons.lock_outline,
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          validator: (v) {
            if (v == null || v.isEmpty) return l10n.fieldRequired;
            if (v.length < 8) return l10n.fieldRequired;
            return null;
          },
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: l10n.confirmPassword,
          controller: confirmCtrl,
          obscureText: true,
          prefixIcon: Icons.lock_outline,
          enabled: !isLoading,
          textInputAction: TextInputAction.done,
          onEditingComplete: onSubmit,
          validator: (v) {
            if (v == null || v.isEmpty) return l10n.fieldRequired;
            if (v != passwordCtrl.text) return l10n.passwordMismatch;
            return null;
          },
        ),
        const SizedBox(height: 20),
        AppButton(
          label: l10n.createAccount,
          isLoading: isLoading,
          onPressed: isLoading ? null : onSubmit,
        ),
      ],
    );
  }
}

// ─── Shared helpers ───────────────────────────────────────────────────────────

class _OrDivider extends StatelessWidget {
  final String label;
  const _OrDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(color: slateGrey, fontSize: 13),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

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

class _AuthFooter extends StatelessWidget {
  final bool isSignUp;
  final AppLocalizations l10n;
  final VoidCallback onToggle;

  const _AuthFooter({
    required this.isSignUp,
    required this.l10n,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (isSignUp) return const SizedBox.shrink();
    return Center(
      child: GestureDetector(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            l10n.noAccountSignUp,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: tealPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
