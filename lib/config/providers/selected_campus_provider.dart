import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/constants/campus_id.dart';

final selectedCampusProvider =
    StateNotifierProvider<SelectedCampusNotifier, String>((ref) {
  return SelectedCampusNotifier();
});

class SelectedCampusNotifier extends StateNotifier<String> {
  late final List<String> _campusName;
  late final List<String> _campusId;

  SelectedCampusNotifier() : super('Cali') {
    _campusName = CampusId.listCampus;
    _campusId = CampusId.campus.keys.toList();
  }

  List<String> get campusName => _campusName;

  void changeCampusById(String campusId) {
    state = CampusId.campus[campusId]!;
  }

  void changeCampus(int campus) {
    state = _campusName[campus];
  }

  String getCampusId() {
    return _campusId[_campusName.indexOf(state)];
  }

  bool isCampusSelected(int campus) {
    return state == _campusName[campus];
  }
}
