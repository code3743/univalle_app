import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../domain/entities/schedule_class.dart';
import '../../domain/entities/weekday.dart';
import '../../schedule_strings.dart';
import '../viewmodels/schedule_view_model.dart';
import '../widgets/schedule_class_tile.dart';
import '../widgets/schedule_day_selector.dart';
import '../widgets/schedule_empty_day.dart';
import '../widgets/schedule_timeline_tile.dart';

class ScheduleView extends ConsumerStatefulWidget {
  const ScheduleView({super.key});

  @override
  ConsumerState<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends ConsumerState<ScheduleView> {
  static const _accents = [
    AppColors.accentBlue,
    AppColors.accentGreen,
    AppColors.accentPurple,
    AppColors.accentAmber,
    AppColors.accentPink,
  ];

  // SIRA schedules don't run classes on Sunday, so it's left out of the
  // selectable days entirely.
  static const _selectableDays = [
    Weekday.monday,
    Weekday.tuesday,
    Weekday.wednesday,
    Weekday.thursday,
    Weekday.friday,
    Weekday.saturday,
  ];

  Weekday? _selectedDay;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (isLoggedIn) {
          if (!isLoggedIn) context.go(AppRoutes.login);
        },
      );
    });

    final scheduleState = ref.watch(scheduleViewModelProvider);

    return AppScaffold(
      title: ScheduleStrings.title,
      scrollable: false,
      body: AsyncValueWidget(
        value: scheduleState,
        onRetry: () => ref.invalidate(scheduleViewModelProvider),
        data: _buildSchedule,
      ),
    );
  }

  Widget _buildSchedule(List<ScheduleClass> classes) {
    if (classes.isEmpty) {
      return const ScheduleEmptyDay(
        message: ScheduleStrings.empty,
        icon: Icons.event_note_outlined,
      );
    }

    final byDay = <Weekday, List<ScheduleClass>>{};
    for (final scheduleClass in classes) {
      byDay.putIfAbsent(scheduleClass.day, () => []).add(scheduleClass);
    }
    final selectedDay = _selectedDay ?? _defaultDay(byDay);
    final dayClasses = List<ScheduleClass>.of(byDay[selectedDay] ?? const [])
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final accentBySubject = _accentBySubject(classes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScheduleDaySelector(
          days: _selectableDays,
          selectedDay: selectedDay,
          onSelected: (day) => setState(() => _selectedDay = day),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: dayClasses.isEmpty
              ? const ScheduleEmptyDay()
              : ListView.builder(
                  itemCount: dayClasses.length,
                  itemBuilder: (context, index) {
                    final scheduleClass = dayClasses[index];
                    final isLast = index == dayClasses.length - 1;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: isLast ? 0 : AppSpacing.sm,
                      ),
                      child: ScheduleTimelineTile(
                        accent: accentBySubject[scheduleClass.subjectCode]!,
                        isLast: isLast,
                        child: ScheduleClassTile(
                          scheduleClass: scheduleClass,
                          accent: accentBySubject[scheduleClass.subjectCode]!,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // On Sunday there's no matching tab (classes don't run that day), so
  // default to the last day up to Saturday that actually has a class.
  Weekday _defaultDay(Map<Weekday, List<ScheduleClass>> byDay) {
    final today = Weekday.values[DateTime.now().weekday - 1];
    if (today != Weekday.sunday) return today;

    for (final day in _selectableDays.reversed) {
      if (byDay[day]?.isNotEmpty ?? false) return day;
    }
    return Weekday.saturday;
  }

  Map<String, Color> _accentBySubject(List<ScheduleClass> classes) {
    final accentBySubject = <String, Color>{};
    for (final scheduleClass in classes) {
      accentBySubject.putIfAbsent(
        scheduleClass.subjectCode,
        () => _accents[accentBySubject.length % _accents.length],
      );
    }
    return accentBySubject;
  }
}
