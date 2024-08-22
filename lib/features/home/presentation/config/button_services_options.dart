import 'dart:ui' show Color;

import 'package:univalle_app/config/routers/app_router_name.dart';
import 'package:univalle_app/core/utils/svg_paths.dart';

class ButtonServicesOptions {
  final String title;
  final String route;
  final String icon;
  final bool isUnderDevelopment;
  final Color primaryColor;

  ButtonServicesOptions({
    required this.title,
    required this.route,
    required this.icon,
    this.primaryColor = const Color(0xFF6A7F93),
    this.isUnderDevelopment = false,
  });
}

final List<ButtonServicesOptions> servicesOptions = [
  ButtonServicesOptions(
    title: 'Calificaciones',
    route: AppRouterName.studentGrades,
    icon: SvgPaths.ratings,
  ),
  ButtonServicesOptions(
    title: 'Tabulado',
    route: AppRouterName.tabulate,
    icon: SvgPaths.tabulated,
  ),
  ButtonServicesOptions(
    title: 'Calificación docente',
    route: AppRouterName.teachingRating,
    icon: SvgPaths.teacherRating,
  ),
  ButtonServicesOptions(
    title: 'Carné digital',
    route: AppRouterName.digitalCard,
    icon: SvgPaths.digitalCard,
  ),
  ButtonServicesOptions(
    title: 'Resolución',
    route: AppRouterName.resolution,
    icon: SvgPaths.resolution,
  ),
  ButtonServicesOptions(
    title: 'Restaurante',
    route: AppRouterName.restaurant,
    icon: SvgPaths.restaurant,
  ),
];
