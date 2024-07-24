class CampusId {
  static const campus = {
    '00': 'Cali',
    '01': 'Buga',
    '02': 'Caicedonia',
    '03': 'Cartago',
    '04': 'Pacífico',
    '05': 'Palmira',
    '06': 'Tuluá',
    '07': 'Zarzal',
    '14': 'Yumbo',
    '17': 'Bogotá',
    '19': 'Convenio Neiva',
    '21': 'Norte del Cauca',
    '26': 'Convenio Barranquilla',
    '33': 'Convenio Tolima',
    '35': 'Convenio Acrip',
    '36': 'Universidad de Nariño',
    '39': 'El Cairo',
    '40': 'Virtual',
    '41': 'Caicedonia Nodo Sevilla',
    '42': 'Norte del Cauca Nodo Mira',
    '43': 'Norte del Cauca Nodo Jamu',
    '44': 'Palmira Nodo Florida',
    '45': 'Palmira Nodo Candelaria',
  };

  static String getCampus(String id) {
    return campus[id] ?? 'Cali';
  }
}
