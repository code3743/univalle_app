class Validate {
  Validate._();
  static String? validateStudentCode(String? code) {
    if (code == null || code.isEmpty) {
      return 'El código del estudiante es requerido';
    }
    if (code.length < 5) {
      return 'El código del estudiante no es válido';
    }
    RegExp regExp = RegExp(r'^[0-9]+-[0-9]+$');
    if (!regExp.hasMatch(code)) {
      return 'El código del estudiante no es válido';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (password.length < 4) {
      return 'La contraseña debe tener al menos 5 caracteres';
    }
    return null;
  }
}
