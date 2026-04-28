import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/router.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/models/vessel.dart';
import 'package:myapp/core/providers/auth_provider.dart';
import 'package:myapp/core/providers/locale_provider.dart';
import 'package:myapp/core/providers/vessel_provider.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/loading_shimmer.dart';
import 'package:myapp/shared/widgets/section_header.dart';
import 'package:myapp/shared/widgets/vessel_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();
    return _AuthenticatedView(user: user);
  }
}

// ── Authenticated view ─────────────────────────────────────────────────────────

class _AuthenticatedView extends ConsumerWidget {
  final User user;
  const _AuthenticatedView({required this.user});

  String get _displayName {
    final name = user.userMetadata?['full_name'] as String?;
    if (name != null && name.isNotEmpty) return name;
    return user.email ?? '';
  }

  String get _initial {
    final n = _displayName;
    return n.isNotEmpty ? n[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: offWhite,
      body: Column(
        children: [
          _NavyHeader(
            user:        user,
            displayName: _displayName,
            initial:     _initial,
            l10n:        l10n,
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                children: [
                  _VesselSection(userId: user.id, l10n: l10n),
                  const SizedBox(height: 24),
                  _PreferencesSection(l10n: l10n),
                  const SizedBox(height: 24),
                  _OtherSection(l10n: l10n),
                  const SizedBox(height: 32),
                  Text(
                    l10n.appVersion,
                    textAlign: TextAlign.center,
                    style: dmMono(fontSize: 10, color: slateLight),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Navy header ────────────────────────────────────────────────────────────────

class _NavyHeader extends StatelessWidget {
  final User user;
  final String displayName;
  final String initial;
  final AppLocalizations l10n;

  const _NavyHeader({
    required this.user,
    required this.displayName,
    required this.initial,
    required this.l10n,
  });

  String _memberSince() {
    try {
      final dt = DateTime.parse(user.createdAt);
      return l10n.memberSince(DateFormat('MMMM yyyy').format(dt));
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      width:   double.infinity,
      color:   navyDeep,
      padding: EdgeInsets.fromLTRB(20, topPad + 20, 20, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width:  52,
            height: 52,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [tealLight, tealPrimary],
                begin:  Alignment.topLeft,
                end:    Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: GoogleFonts.dmSans(
                  fontSize:   20,
                  fontWeight: FontWeight.w700,
                  color:      Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name + email + member since
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: GoogleFonts.dmSans(
                    fontSize:   16,
                    fontWeight: FontWeight.w700,
                    color:      Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.email != null && user.email!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    user.email!,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color:    Colors.white.withValues(alpha: 0.65),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _memberSince(),
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    color:    Colors.white.withValues(alpha: 0.40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── My Vessels section ─────────────────────────────────────────────────────────

class _VesselSection extends ConsumerWidget {
  final String userId;
  final AppLocalizations l10n;

  const _VesselSection({required this.userId, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vesselsAsync = ref.watch(userVesselsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          label: l10n.myVessels,
          action: TextButton(
            onPressed: () => context.push(Routes.addVessel),
            child: Text(
              l10n.addVessel,
              style: GoogleFonts.dmSans(
                fontSize:   13,
                fontWeight: FontWeight.w600,
                color:      tealPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        vesselsAsync.when(
          loading: () => Column(
            children: [
              LoadingShimmer(height: 76, borderRadius: radiusCard),
              const SizedBox(height: 8),
              LoadingShimmer(height: 76, borderRadius: radiusCard),
            ],
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (vessels) {
            if (vessels.isEmpty) return _DashedAddButton(l10n: l10n);

            return Column(
              children: vessels.map((v) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Dismissible(
                    key:       ValueKey(v.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) => _confirmDelete(context, v),
                    onDismissed:    (_) => _deleteVessel(context, ref, v),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding:   const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color:        dangerRed,
                        borderRadius: BorderRadius.circular(radiusCard),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size:  24,
                      ),
                    ),
                    child: VesselCard(vessel: v),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, Vessel v) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l10n.deleteVesselTitle,
          style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w700, color: navyDeep),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.backAction),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.removeAction,
              style: const TextStyle(color: dangerRed),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteVessel(
    BuildContext context,
    WidgetRef ref,
    Vessel v,
  ) async {
    try {
      await ref
          .read(vesselRepositoryProvider)
          .deleteVessel(v.id, ownerId: userId);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorNetwork,
              style: GoogleFonts.dmSans(color: Colors.white),
            ),
            backgroundColor: dangerRed,
          ),
        );
      }
    } finally {
      ref.invalidate(userVesselsProvider);
    }
  }
}

class _DashedAddButton extends StatelessWidget {
  final AppLocalizations l10n;
  const _DashedAddButton({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.addVessel),
      child: Container(
        width:  double.infinity,
        height: 76,
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(radiusCard),
          border: Border.all(color: slateLight, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 20, color: tealPrimary),
            const SizedBox(width: 8),
            Text(
              l10n.addFirstVessel,
              style: GoogleFonts.dmSans(
                fontSize:   14,
                fontWeight: FontWeight.w500,
                color:      tealPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Preferences section ────────────────────────────────────────────────────────

class _PreferencesSection extends ConsumerWidget {
  final AppLocalizations l10n;
  const _PreferencesSection({required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale      = ref.watch(localeProvider);
    final localeLabel = locale.languageCode == 'et' ? 'Eesti' : 'English';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(label: l10n.preferences),
        const SizedBox(height: 12),
        _SettingsCard(
          children: [
            _SettingsItem(
              icon:  Icons.notifications_outlined,
              label: l10n.notifications,
              sub:   l10n.notificationsSubtitle,
            ),
            const Divider(color: borderColor, height: 1),
            _SettingsItem(
              icon:  Icons.language_outlined,
              label: l10n.language,
              sub:   localeLabel,
              onTap: () => _showLanguagePicker(context, ref),
            ),
            const Divider(color: borderColor, height: 1),
            _SettingsItem(
              icon:  Icons.credit_card_outlined,
              label: l10n.paymentMethods,
              sub:   l10n.paymentMethodsSubtitle,
            ),
          ],
        ),
      ],
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radiusBottomSheet),
        ),
      ),
      builder: (sheetCtx) => Consumer(
        builder: (_, innerRef, __) {
          final current = innerRef.watch(localeProvider);
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width:  40,
                  height: 4,
                  decoration: BoxDecoration(
                    color:        borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.language,
                  style: GoogleFonts.dmSans(
                    fontSize:   17,
                    fontWeight: FontWeight.w700,
                    color:      navyDeep,
                  ),
                ),
                const SizedBox(height: 16),
                _LocaleOption(
                  label:    'English',
                  selected: current.languageCode == 'en',
                  onSelect: () {
                    innerRef
                        .read(localeProvider.notifier)
                        .setLocale(const Locale('en'));
                    Navigator.of(sheetCtx).pop();
                  },
                ),
                const SizedBox(height: 8),
                _LocaleOption(
                  label:    'Eesti',
                  selected: current.languageCode == 'et',
                  onSelect: () {
                    innerRef
                        .read(localeProvider.notifier)
                        .setLocale(const Locale('et'));
                    Navigator.of(sheetCtx).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LocaleOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelect;

  const _LocaleOption({
    required this.label,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:        onSelect,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width:   double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color:        selected ? tealPale : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? tealPrimary : borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize:   15,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color:      selected ? tealPrimary : navyDeep,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(Icons.check_circle, color: tealPrimary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Other section ──────────────────────────────────────────────────────────────

class _OtherSection extends ConsumerWidget {
  final AppLocalizations l10n;
  const _OtherSection({required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SettingsCard(
      children: [
        _SettingsItem(
          icon:  Icons.description_outlined,
          label: l10n.termsPrivacy,
          onTap: _openTerms,
        ),
        const Divider(color: borderColor, height: 1),
        _SettingsItem(
          icon:     Icons.logout,
          label:    l10n.signOut,
          isDanger: true,
          onTap:    () => _showSignOutDialog(context, ref),
        ),
      ],
    );
  }

  Future<void> _openTerms() async {
    final uri = Uri.parse('https://sadamaagent.ee/terms');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _showSignOutDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l10n.signOutConfirmTitle,
          style:
              GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: navyDeep),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.backAction),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.signOut,
              style: const TextStyle(color: dangerRed),
            ),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;
    await ref.read(authProvider.notifier).signOut();
    if (context.mounted) context.go(Routes.ports);
  }
}

// ── Shared local widgets ───────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(radiusCard),
        border:       Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radiusCard),
        child: Column(children: children),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sub;
  final bool isDanger;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.sub,
    this.isDanger = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = isDanger ? dangerRed : navyDeep;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon box
            Container(
              width:  32,
              height: 32,
              decoration: BoxDecoration(
                color: isDanger
                    ? dangerRed.withValues(alpha: 0.10)
                    : tealPale,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size:  18,
                color: isDanger ? dangerRed : tealPrimary,
              ),
            ),
            const SizedBox(width: 14),

            // Label + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.dmSans(
                      fontSize:   14,
                      fontWeight: FontWeight.w500,
                      color:      labelColor,
                    ),
                  ),
                  if (sub != null)
                    Text(
                      sub!,
                      style: GoogleFonts.dmSans(
                          fontSize: 12, color: slateGrey),
                    ),
                ],
              ),
            ),

            if (!isDanger)
              const Icon(Icons.chevron_right, size: 18, color: slateLight),
          ],
        ),
      ),
    );
  }
}
