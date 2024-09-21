import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/widgets/widget_error.dart';
import 'package:univalle_app/features/restaurant/presentation/providers/student_restarant_provider.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/widgets.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/ticket_information.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurante'),
      ),
      backgroundColor: AppColors.primaryRed,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(0, 0),
                        )
                      ],
                    ),
                    child: Consumer(builder: (_, ref, __) {
                      return FutureBuilder(
                          future: ref.watch(studentRestaurantProvider.future),
                          builder: (_, snapshot) {
                            if (snapshot.hasError) {
                              return WidgetError(
                                message: snapshot.error.toString(),
                                onRetry: () {
                                  final _ =
                                      ref.refresh(studentRestaurantProvider);
                                },
                              );
                            }

                            if (!snapshot.hasData) {
                              //TODO: Implement loading widget
                              return const SizedBox(
                                height: 300,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            return TicketInformation(
                                studentRestaurant: snapshot.data!);
                          });
                    })),
              ),
              const SeparatorTicket()
            ],
          ),
        ),
      ),
    );
  }
}
