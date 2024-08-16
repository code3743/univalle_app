import 'package:univalle_app/features/restaurant/domain/entities/student_restaurant.dart';

abstract class StudentRestaurantRepository {
  Future<StudentRestaurant> getStudentRestaurant(String user, String password);
  Future<void> buyLunches(int numberLunch, double total);
}
