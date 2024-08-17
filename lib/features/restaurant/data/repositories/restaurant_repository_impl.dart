import 'package:univalle_app/features/restaurant/domain/datasources/student_restaurant_datasource.dart';
import 'package:univalle_app/features/restaurant/domain/entities/payment_process.dart';
import 'package:univalle_app/features/restaurant/domain/entities/student_restaurant.dart';
import 'package:univalle_app/features/restaurant/domain/repositories/student_restaurant_repository.dart';

class RestaurantRepositoryImpl implements StudentRestaurantRepository {
  final StudentRestaurantDatasource _datasource;

  RestaurantRepositoryImpl(this._datasource);

  @override
  Future<PaymentProcess> buyLunches(int numberLunch, double total) {
    return _datasource.buyLunches(numberLunch, total);
  }

  @override
  Future<StudentRestaurant> getStudentRestaurant(String user, String password) {
    return _datasource.getStudentRestaurant(user, password);
  }
}
