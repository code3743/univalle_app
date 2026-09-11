class Campus {
  final String code;
  final String name;
  const Campus({required this.code, required this.name});
}

abstract final class CampusCodes {
  static const List<Campus> all = [
    Campus(code: '00', name: 'Cali'),
    Campus(code: '01', name: 'Buga'),
    Campus(code: '02', name: 'Caicedonia'),
    Campus(code: '03', name: 'Cartago'),
    Campus(code: '04', name: 'Pacífico'),
    Campus(code: '05', name: 'Palmira'),
    Campus(code: '06', name: 'Tuluá'),
    Campus(code: '07', name: 'Zarzal'),
    Campus(code: '14', name: 'Yumbo'),
    Campus(code: '17', name: 'Bogotá'),
    Campus(code: '19', name: 'Convenio Neiva'),
    Campus(code: '21', name: 'Norte del Cauca'),
    Campus(code: '26', name: 'Convenio Barranquilla'),
    Campus(code: '33', name: 'Convenio Tolima'),
    Campus(code: '35', name: 'Convenio ACRIP'),
    Campus(code: '36', name: 'Universidad de Nariño'),
    Campus(code: '39', name: 'El Cairo'),
    Campus(code: '40', name: 'Virtual'),
    Campus(code: '41', name: 'Caicedonia Nodo Sevilla'),
    Campus(code: '42', name: 'Norte del Cauca Nodo Mira'),
    Campus(code: '43', name: 'Norte del Cauca Nodo Jamu'),
    Campus(code: '44', name: 'Palmira Nodo Florida'),
    Campus(code: '45', name: 'Palmira Nodo Candelaria'),
    Campus(code: '46', name: 'Norte del Cauca Nodo Suárez'),
  ];

  static String nameFor(String code) {
    for (final campus in all) {
      if (campus.code == code) return campus.name;
    }
    return code;
  }
}
