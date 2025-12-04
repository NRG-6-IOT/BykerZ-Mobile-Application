// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get dashboard => 'Panel de Control';

  @override
  String get maintenance => 'Mantenimiento';

  @override
  String get monitoring => 'Monitoreo';

  @override
  String get expenses => 'Gastos';

  @override
  String get vehicles => 'Vehiculos';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get expenseDetails => 'Detalles del Gasto';

  @override
  String get createExpense => 'Crear Gasto';

  @override
  String get vehicleDetails => 'Detalles del Vehiculo';

  @override
  String get createVehicle => 'Crear Vehiculo';

  @override
  String get metrics => 'Métricas';

  @override
  String get ownerIdNotFound =>
      'ID de propietario no encontrado. Por favor, inicie sesión nuevamente.';

  @override
  String get loadingMaintenances => 'Cargando mantenimientos...';

  @override
  String get retry => 'Reintentar';

  @override
  String get scheduledMaintenances => 'Mantenimientos Programados';

  @override
  String get noScheduledMaintenances => 'No hay mantenimientos programados';

  @override
  String get maintenancesDone => 'Mantenimientos Completados';

  @override
  String get noCompletedMaintenances => 'No hay mantenimientos completados';

  @override
  String get pullToRefresh => 'Tira para actualizar';

  @override
  String get dateAndTime => 'Fecha y Hora';

  @override
  String get location => 'Ubicación';

  @override
  String get mechanic => 'Mecánico';

  @override
  String get vehicle => 'Vehículo';

  @override
  String get details => 'Detalles';

  @override
  String get expense => 'Gasto';

  @override
  String get seeExpenseDetails => 'Ver Detalles del Gasto';

  @override
  String get loading => 'Cargando...';

  @override
  String get deleteExpense => 'Eliminar Gasto';

  @override
  String get deleteExpenseConfirmation =>
      '¿Estás seguro de que quieres eliminar este gasto? Esta acción no se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get expenseDeletedSuccessfully => 'Gasto eliminado exitosamente';

  @override
  String get loadingExpenses => 'Cargando gastos...';

  @override
  String get noExpensesFound => 'No se encontraron gastos';

  @override
  String get clickToCreateFirstExpense =>
      'Haz clic en el botón + para crear tu primer gasto.';

  @override
  String get allExpenses => 'Todos los Gastos';

  @override
  String get totalExpenses => 'gastos totales';

  @override
  String get tapToLoadExpenses => 'Toca para cargar gastos';

  @override
  String get newExpense => 'Nuevo Gasto';

  @override
  String get loadingDetails => 'Cargando detalles...';

  @override
  String get goBack => 'Regresar';

  @override
  String get loadingExpenseDetails => 'Cargando detalles del gasto...';

  @override
  String get expenseName => 'Nombre del Gasto';

  @override
  String get items => 'Artículos';

  @override
  String get noItemsFound => 'No se encontraron artículos';

  @override
  String get finalPrice => 'Precio Final';

  @override
  String get fillAllItemFields =>
      'Por favor, complete todos los campos del artículo';

  @override
  String get invalidAmountOrPrice =>
      'La cantidad debe ser mayor a 0 y el precio unitario no puede ser negativo';

  @override
  String get enterExpenseName => 'Por favor, ingrese un nombre para el gasto';

  @override
  String get addAtLeastOneItem => 'Por favor, agregue al menos un artículo';

  @override
  String get errorCreatingExpense => 'Error al crear el gasto';

  @override
  String get expenseCreatedSuccessfully => '¡Gasto creado exitosamente!';

  @override
  String get itemName => 'Nombre del Artículo';

  @override
  String get amount => 'Cantidad';

  @override
  String get unitPrice => 'Precio Unitario';

  @override
  String get itemType => 'Tipo de Artículo';

  @override
  String get addItem => 'Agregar Artículo';

  @override
  String get addItems => 'Agregar Artículos';

  @override
  String get addedItems => 'Artículos Agregados';

  @override
  String get totalSum => 'Suma Total';

  @override
  String get saveExpense => 'Guardar Gasto';

  @override
  String get pending => 'Pendiente';

  @override
  String get inProgress => 'En Progreso';

  @override
  String get completed => 'Completado';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get itemTypeFine => 'Multa';

  @override
  String get itemTypeParking => 'Estacionamiento';

  @override
  String get itemTypePayment => 'Pago';

  @override
  String get itemTypeSupplies => 'Suministros';

  @override
  String get itemTypeTax => 'Impuesto';

  @override
  String get itemTypeTools => 'Herramientas';

  @override
  String get noNotificationsAvailable => 'No hay notificaciones disponibles.';

  @override
  String get reloadNotifications => 'Recargar notificaciones';

  @override
  String get markAsRead => 'Marcar como leído';

  @override
  String get close => 'Cerrar';

  @override
  String get seeMore => 'Ver más';

  @override
  String get newAlert => 'Nueva Alerta';

  @override
  String get type => 'Tipo';

  @override
  String get severity => 'Severidad';

  @override
  String get date => 'Fecha';

  @override
  String get allNotifications => 'Todas las notificaciones';

  @override
  String get alertsForVehicle => 'Alertas - Vehículo';

  @override
  String get now => 'Ahora';

  @override
  String get minutesAgo => 'min atrás';

  @override
  String get hoursAgo => 'h atrás';

  @override
  String get connectedReceivingAlerts =>
      'Conectado - Recibiendo alertas en tiempo real';

  @override
  String get forVehicle => 'para vehículo';

  @override
  String get disconnectedAlertsUnavailable =>
      'Desconectado - Las alertas en tiempo real no están disponibles';

  @override
  String get severityHigh => 'ALTA';

  @override
  String get severityMedium => 'MEDIA';

  @override
  String get severityLow => 'BAJA';

  @override
  String get title => 'Título';

  @override
  String get message => 'Mensaje';

  @override
  String get tryAgain => 'Intentar nuevamente';

  @override
  String get noWellnessMetrics =>
      'No hay métricas de bienestar para este vehículo';

  @override
  String get loadingWellnessMetrics => 'Cargando métricas de bienestar...';

  @override
  String get loadWellnessMetrics => 'Cargar métricas de bienestar';

  @override
  String get metric => 'Métrica';

  @override
  String get airQuality => 'Calidad del Aire';

  @override
  String get conditions => 'Condiciones';

  @override
  String get pressure => 'Presión';

  @override
  String get emittedAt => 'Emitido En';

  @override
  String get impact => 'Impacto';

  @override
  String get normal => 'Normal';

  @override
  String get temperature => 'Temperatura';

  @override
  String get humidity => 'Humedad';

  @override
  String get co2 => 'CO₂';

  @override
  String get nh3 => 'NH₃';

  @override
  String get benzene => 'Benceno';

  @override
  String get ppm => 'ppm';

  @override
  String get hPa => 'hPa';

  @override
  String get notAvailable => 'N/D';

  @override
  String get addNewVehicle => 'Agregar Nuevo Vehículo';

  @override
  String get plateFormat => 'Placa (ej. 1234-XY)';

  @override
  String get invalidPlateFormat => 'Formato inválido. Debe ser 1234-XY';

  @override
  String get year => 'Año';

  @override
  String get brand => 'Marca';

  @override
  String get model => 'Modelo';

  @override
  String get create => 'Crear';

  @override
  String get addVehicle => 'Agregar Vehículo';

  @override
  String get noVehiclesFound => 'No se encontraron vehículos';

  @override
  String get viewDetails => 'Ver Detalles';

  @override
  String get vehicleInformation => 'Información del Vehículo';

  @override
  String get plate => 'Placa';

  @override
  String get modelYear => 'Año del Modelo';

  @override
  String get technicalSpecifications => 'Especificaciones Técnicas';

  @override
  String get engine => 'Motor';

  @override
  String get power => 'Potencia';

  @override
  String get torque => 'Torque';

  @override
  String get weight => 'Peso';

  @override
  String get fuelTank => 'Tanque de Combustible';

  @override
  String get transmission => 'Transmisión';
}
