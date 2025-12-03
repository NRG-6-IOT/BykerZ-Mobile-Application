import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:byker_z_mobile/vehicle_management/model/vehicle_create_request.dart';
import 'package:byker_z_mobile/vehicle_management/model/vehicle_model.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_event.dart';
import 'package:byker_z_mobile/l10n/app_localizations.dart';
import '../bloc/vehicle/vehicle_state.dart';

class VehicleCreateDialog extends StatelessWidget {
  const VehicleCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    context.read<VehicleBloc>().add(LoadVehicleCreateFormEvent());

    final currentYear = DateTime.now().year;
    final years = List.generate(50, (i) => (currentYear - i).toString());

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleCreateFormLoading) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35))),
            );
          }

          if (state is VehicleCreateFormError) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }

          if (state is! VehicleCreateFormLoaded) {
            return const SizedBox.shrink();
          }

          final form = state;
          final brands = form.allModels.map((e) => e.brand).toSet().toList()..sort();
          final plateRegex = RegExp(r'^[0-9]{4}-[A-Z]{2}$');
          final isPlateValid = plateRegex.hasMatch(form.plate);

          return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFFFF6B35)),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        localizations.addNewVehicle,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Plate
                  _buildTextField(
                    label: localizations.plateFormat,
                    icon: Icons.tag,
                    onChanged: (value) => context.read<VehicleBloc>().add(UpdateCreatePlateEvent(value.toUpperCase())),
                  ),
                  if (!isPlateValid && form.plate.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Text(
                        localizations.invalidPlateFormat,
                        style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Year
                  _buildDropdown<String>(
                    label: localizations.year,
                    icon: Icons.calendar_today_rounded,
                    value: form.year,
                    items: years.map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
                    onChanged: (value) => context.read<VehicleBloc>().add(UpdateCreateYearEvent(value!)),
                  ),

                  const SizedBox(height: 16),

                  // Brand
                  _buildDropdown<String>(
                    label: localizations.brand,
                    icon: Icons.branding_watermark_rounded,
                    value: form.selectedBrand,
                    items: brands.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                    onChanged: (value) => context.read<VehicleBloc>().add(SelectCreateBrandEvent(value!)),
                  ),

                  const SizedBox(height: 16),

                  // Model
                  _buildDropdown<Model>(
                    label: localizations.model,
                    icon: Icons.motorcycle_rounded,
                    value: form.filteredModels.contains(form.selectedModel) ? form.selectedModel : null,
                    items: form.filteredModels.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
                    onChanged: (m) => context.read<VehicleBloc>().add(SelectCreateModelEvent(m!)),
                  ),

                  const SizedBox(height: 32),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: Text(localizations.cancel, style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (!isPlateValid || form.year == null || form.year!.isEmpty || form.selectedModel == null)
                              ? null
                              : () {
                            final request = VehicleCreateRequest(
                              plate: form.plate,
                              year: form.year!,
                              modelId: form.selectedModel!.id,
                            );
                            context.read<VehicleBloc>().add(CreateVehicleForOwnerIdEvent(request: request));
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text(localizations.create, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
          },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFFF6B35)),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2)),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFFF6B35)),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2)),
      ),
    );
  }
}