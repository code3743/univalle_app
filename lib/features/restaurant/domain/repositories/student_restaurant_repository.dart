import 'package:univalle_app/features/restaurant/domain/entities/payment_process.dart';
import 'package:univalle_app/features/restaurant/domain/entities/student_restaurant.dart';

abstract class StudentRestaurantRepository {
  Future<StudentRestaurant> getStudentRestaurant(String user, String password);
  Future<PaymentProcess> buyLunches(int numberLunch, double total);
}
