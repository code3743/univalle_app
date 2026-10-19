import 'package:univalle_app/core/domain/entities/app_config.dart';
import 'package:univalle_app/core/domain/entities/app_module.dart';
import 'package:univalle_app/core/domain/entities/student.dart';
import 'package:univalle_app/core/domain/entities/welcome_banner.dart';

Student fakeStudent({
  String firstName = 'Juan',
  String lastName = 'Pérez',
  String programName = 'Ingeniería de Sistemas',
  String campus = 'Meléndez',
  double average = 4.1,
  int accumulatedCredits = 120,
}) => Student(
  documentId: '1234567',
  firstName: firstName,
  lastName: lastName,
  email: 'juan.perez@correounivalle.edu.co',
  programName: programName,
  campus: campus,
  average: average,
  accumulatedCredits: accumulatedCredits,
);

AppModule fakeAppModule({
  String key = 'grades',
  String label = 'Notas',
  String icon = 'notebook-text',
  String route = '/grades',
  String color = '#C8102E',
  bool disabled = false,
  String? disabledMessage,
}) => AppModule(
  key: key,
  label: label,
  icon: icon,
  route: route,
  color: color,
  disabled: disabled,
  disabledMessage: disabledMessage,
);

AppConfig fakeAppConfig({
  bool platformEnabled = true,
  MaintenanceStatus maintenance = const MaintenanceStatus(
    enabled: false,
    title: '',
    message: '',
  ),
  UpdateStatus update = const UpdateStatus(
    latestVersion: '1.0.0',
    updateAvailable: false,
    updateRequired: false,
    storeUrl: '',
    message: '',
  ),
  List<AppModule> modules = const [],
  List<String> quickAccess = const [],
  WelcomeBanner welcome = const WelcomeBanner(
    enabled: false,
    title: '',
    description: '',
  ),
}) => AppConfig(
  platformEnabled: platformEnabled,
  maintenance: maintenance,
  update: update,
  modules: modules,
  quickAccess: quickAccess,
  welcome: welcome,
);
