import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/features/restaurant/domain/entities/lunch_payment.dart';
import 'package:univalle_app/features/restaurant/domain/entities/restaurant_account.dart';
import 'package:univalle_app/features/restaurant/domain/repositories/restaurant_repository.dart';

class MockRestaurantRepository extends Mock implements RestaurantRepository {}

const pendingPayment = LunchPayment(
  quantity: 3,
  total: 10500,
  purchaseDate: '2026-01-01',
  expirationDate: '2026-01-02',
  message: 'Tienes un pago en proceso',
  paymentUrl: 'https://pay.example/1',
);

RestaurantAccount account({
  int accumulatedLunches = 4,
  LunchPayment? pending,
}) => RestaurantAccount(
  membershipType: 'Estudiante',
  lunchPrice: 3500,
  accumulatedLunches: accumulatedLunches,
  minPurchase: 2,
  maxPurchase: 10,
  pendingPayment: pending,
);
