abstract final class RestaurantStrings {
  static const title = 'Restaurante';
  static const cafeteriaOnlyNotice =
      'Esta opción aplica únicamente para las sedes en Cali.';
  static const accumulatedLunches = 'Almuerzos acumulados';
  static const membershipTypeLabel = 'Tipo de vinculación';
  static const lunchPriceLabel = 'Valor del almuerzo';
  static const noPaymentDisclaimer =
      'Esta aplicación no recauda dinero ni procesa pagos. Se te '
      'proporcionará un enlace para que te dirijas al sitio oficial de la '
      'universidad y completes el pago de los almuerzos.';

  static const buyTitle = 'Comprar almuerzos';
  static const totalToPayLabel = 'Total a pagar';
  static const buySubmit = 'Comprar';
  static const quantityRequired = 'Ingresa un valor';
  static const quantityInvalid = 'Ingresa un valor numérico';
  static String quantityBelowMin(int min) => 'Lo mínimo es $min';
  static String quantityAboveMax(int max) => 'Lo máximo es $max';

  static const confirmPurchaseTitle =
      '¿Estás seguro de querer comprar estos almuerzos?';
  static const confirmPurchaseBody =
      'Al confirmar la compra se generará un enlace para que te dirijas al '
      'portal de pagos de la universidad.';
  static const confirmLabel = 'Confirmar';
  static const cancelLabel = 'Cancelar';

  static const pendingPaymentTitle = 'Compra en proceso';
  static const purchaseDateLabel = 'Fecha de inicio';
  static const quantityLabel = 'Cantidad de almuerzos';
  static const expirationDateLabel = 'Fecha de expiración';
  static const goToPayLabel = 'Ir a pagar';
  static const confirmPaymentLabel = 'Ya pagué';
  static const cannotOpenPaymentLink = 'No pudimos abrir el enlace de pago.';

  static const paymentConfirmed = '¡Tu pago fue confirmado!';
  static const paymentStillPending =
      'Tu pago aún no se refleja, intenta de nuevo en unos minutos.';

  static const noPaymentLink = 'No se pudo generar el enlace de pago.';
  static const noToken = 'No se pudo obtener el token de acceso.';
  static const serviceUnavailable = 'El servicio no está disponible.';
  static const accountUnavailable =
      'No pudimos obtener tu información del restaurante.';
}
