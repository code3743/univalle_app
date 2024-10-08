import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/routers/app_router_name.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/core/common/widgets/loading.dart';
import 'package:univalle_app/features/teaching_rating/presentation/providers/teaching_rating_provider.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/message_rating.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/teaching_rating_item.dart';

class TeachingRatingScreen extends ConsumerWidget {
  const TeachingRatingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachingProvider = ref.watch(teachingRatingProvider);
    final teachingNotifier = ref.read(teachingRatingProvider.notifier);
    final scaffoldKey = GlobalKey<ScaffoldState>();
    if (teachingProvider == null) {
      teachingNotifier.getTeachingRating();
      return Scaffold(
          appBar: AppBar(
            title: const Text('Calificación Docente'),
          ),
          body: const Center(child: Loading(text: 'Buscando docentes...')));
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Calificación Docente'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Builder(builder: (context) {
          Future.microtask(() {
            scaffoldKey.currentState?.showBottomSheet((context) {
              return const MessageRating();
            }, backgroundColor: Colors.transparent);
          });

          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => TeachingRatingItem(
                          name: teachingProvider[index].teacherName,
                          subject: teachingProvider[index].subjectName,
                          isRated: teachingProvider[index].isQualified,
                          onTap: () {
                            if (teachingProvider[index].isQualified) {
                              ref
                                  .read(snackBarHandlerProvider)
                                  .showSnackBarSuccess(
                                      'El docente ya ha sido calificado');
                              return;
                            }
                            if (teachingProvider[index].novelty != null) {
                              ref
                                  .read(snackBarHandlerProvider)
                                  .showSnackBarInfo(
                                      teachingProvider[index].novelty!);
                              return;
                            }
                            context.push(AppRouterName.teachingRatingDetails,
                                extra: index);
                          }),
                      childCount: teachingProvider.length)),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
