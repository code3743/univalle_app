import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../domain/entities/schedule_class.dart';
import '../../domain/entities/weekday.dart';
import '../../schedule_strings.dart';
import '../utils/schedule_day_agenda.dart';
import '../viewmodels/schedule_view_model.dart';
import '../widgets/schedule_class_tile.dart';
import '../widgets/schedule_day_selector.dart';
import '../widgets/schedule_empty_day.dart';
import '../widgets/schedule_skeleton.dart';
import '../widgets/schedule_timeline_tile.dart';

class ScheduleView extends ConsumerStatefulWidget {
  const ScheduleView({super.key});

  @override
  ConsumerState<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends ConsumerState<ScheduleView> {
  Weekday? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final scheduleState = ref.watch(scheduleViewModelProvider);

    return AppScaffold(
      title: ScheduleStrings.title,
      scrollable: false,
      body: AsyncValueWidget(
        value: scheduleState,
        onRetry: () => ref.invalidate(scheduleViewModelProvider),
        skeleton: const ScheduleSkeleton(),
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

    final agenda = ScheduleDayAgenda.from(classes, selectedDay: _selectedDay);
    final dayClasses = agenda.dayClasses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScheduleDaySelector(
          days: scheduleSelectableDays,
          selectedDay: agenda.selectedDay,
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
                    final accent =
                        agenda.accentBySubject[scheduleClass.subjectCode]!;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: isLast ? 0 : AppSpacing.sm,
                      ),
                      child: ScheduleTimelineTile(
                        accent: accent,
                        isLast: isLast,
                        child: ScheduleClassTile(
                          scheduleClass: scheduleClass,
                          accent: accent,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
