import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme.dart';
import '../../core/supabase/supabase_client.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_button.dart';

class SignupConfirmationScreen extends HookConsumerWidget {
  final String email;
  const SignupConfirmationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final secondsLeft = useState(60);
    final isResending = useState(false);

    // Decrement countdown by 1 each second while counting.
    useEffect(() {
      if (secondsLeft.value == 0) return null;
      final timer = Timer(const Duration(seconds: 1), () {
        secondsLeft.value--;
      });
      return timer.cancel;
    }, [secondsLeft.value]);

    Future<void> resend() async {
      if (secondsLeft.value > 0 || isResending.value) return;
      isResending.value = true;
      try {
        await supabase.auth.resend(type: OtpType.signup, email: email);
        secondsLeft.value = 60;
      } finally {
        isResending.value = false;
      }
    }

    Future<void> openMail() async {
      final uri = Uri(scheme: 'mailto');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: tealPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mail_outline_rounded,
                  size: 44,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.signupConfirmationTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: navyDeep,
                  letterSpacing: -0.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.signupConfirmationMessage(email),
                style: const TextStyle(
                  fontSize: 15,
                  color: slateGrey,
                  height: 1.55,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              AppButton(
                label: l10n.openMailApp,
                onPressed: openMail,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => context.goNamed('login'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    l10n.backToSignIn,
                    style: const TextStyle(
                      color: tealPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    l10n.didntGetEmail,
                    style: const TextStyle(fontSize: 13, color: slateGrey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  secondsLeft.value > 0
                      ? Text(
                          l10n.resendIn(secondsLeft.value),
                          style: const TextStyle(
                            fontSize: 13,
                            color: slateLight,
                          ),
                        )
                      : GestureDetector(
                          onTap: isResending.value ? null : resend,
                          child: Text(
                            l10n.resendNow,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color:
                                  isResending.value ? slateLight : tealPrimary,
                            ),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
