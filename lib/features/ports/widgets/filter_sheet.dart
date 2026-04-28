import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/providers/ports_provider.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/app_button.dart';

/// Bottom sheet for filtering ports by vessel dimensions and date range.
///
/// Reads the current [portSearchParamsProvider] to pre-fill sliders, then
/// writes back via [portSearchParamsProvider.notifier] when "Apply" is tapped.
class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late double _vesselLength;
  late double _vesselDraft;
  DateTime? _arrival;
  DateTime? _departure;

  @override
  void initState() {
    super.initState();
    final params = ref.read(portSearchParamsProvider);
    _vesselLength = params.vesselLength ?? 15.0;
    _vesselDraft = params.vesselDraft ?? 1.5;
    _arrival = params.arrival;
    _departure = params.departure;
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _arrival != null && _departure != null
          ? DateTimeRange(start: _arrival!, end: _departure!)
          : null,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: tealPrimary,
                onPrimary: Colors.white,
              ),
        ),
        child: child!,
      ),
    );
    if (range != null) {
      setState(() {
        _arrival = range.start;
        _departure = range.end;
      });
    }
  }

  void _apply() {
    ref.read(portSearchParamsProvider.notifier).update(
          (p) => p.copyWith(
            vesselLength: _vesselLength,
            vesselDraft: _vesselDraft,
            arrival: _arrival,
            departure: _departure,
          ),
        );
    Navigator.of(context).pop();
  }

  void _reset() {
    ref
        .read(portSearchParamsProvider.notifier)
        .update((_) => const PortSearchParams());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radiusBottomSheet),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            l10n.filterSheetTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 28),
          _SliderRow(
            label:
                '${l10n.vesselLength}  ${_vesselLength.toStringAsFixed(0)} m',
            value: _vesselLength,
            min: 0,
            max: 30,
            onChanged: (v) => setState(() => _vesselLength = v),
          ),
          const SizedBox(height: 20),
          _SliderRow(
            label:
                '${l10n.vesselDraft}  ${_vesselDraft.toStringAsFixed(1)} m',
            value: _vesselDraft,
            min: 0,
            max: 3,
            onChanged: (v) => setState(() => _vesselDraft = v),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.arrivalDate,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: slateGrey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          _DateRangeButton(
            arrival: _arrival,
            departure: _departure,
            onTap: _pickDateRange,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.filterReset,
                  variant: AppButtonVariant.ghost,
                  onPressed: _reset,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: l10n.filterApply,
                  onPressed: _apply,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: navyDeep,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: tealPrimary,
            inactiveTrackColor: borderColor,
            thumbColor: tealPrimary,
            overlayColor: tealPrimary.withValues(alpha: 0.12),
            trackHeight: 3,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _DateRangeButton extends StatelessWidget {
  final DateTime? arrival;
  final DateTime? departure;
  final VoidCallback onTap;

  const _DateRangeButton({
    required this.arrival,
    required this.departure,
    required this.onTap,
  });

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasRange = arrival != null && departure != null;
    final label = hasRange
        ? '${_fmt(arrival!)}  →  ${_fmt(departure!)}'
        : l10n.selectDates;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
          color: offWhite,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 17, color: slateGrey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: hasRange ? navyDeep : slateLight,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: slateLight),
          ],
        ),
      ),
    );
  }
}
