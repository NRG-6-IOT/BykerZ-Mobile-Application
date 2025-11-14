import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:byker_z_mobile/vehicle_management/model/vehicle_create_request.dart';
import 'package:byker_z_mobile/vehicle_management/model/vehicle_model.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_event.dart';
import '../bloc/vehicle/vehicle_state.dart';

class VehicleCreateDialog extends StatelessWidget {
  const VehicleCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<VehicleBloc>().add(LoadVehicleCreateFormEvent());

    final currentYear = DateTime.now().year;
    final years = List.generate(50, (i) => (currentYear - i).toString());

    return AlertDialog(
      title: const Text("Create Vehicle"),
      content: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleCreateFormLoading) {
            return const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is VehicleCreateFormError) {
            return Text(state.message);
          }

          if (state is! VehicleCreateFormLoaded) {
            return const SizedBox.shrink();
          }

          final form = state;

          final brands = form.allModels.map((e) => e.brand).toSet().toList()
            ..sort();

          final plateRegex = RegExp(r'^[0-9]{4}-[A-Z]{2}$');
          final isPlateValid = plateRegex.hasMatch(form.plate);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Plate
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Plate",
                ),
                onChanged: (value) {
                  context.read<VehicleBloc>().add(
                    UpdateCreatePlateEvent(value.toUpperCase()),
                  );
                },
              ),

              if (!isPlateValid && form.plate.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Formato inválido. Debe ser 1234-XY",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),

              const SizedBox(height: 15),

              // Year
              DropdownButtonFormField<String>(
                value: form.year,
                decoration: const InputDecoration(labelText: "Year"),
                items: years
                    .map((y) => DropdownMenuItem(
                  value: y,
                  child: Text(y),
                ))
                    .toList(),
                onChanged: (value) {
                  context
                      .read<VehicleBloc>()
                      .add(UpdateCreateYearEvent(value!));
                },
              ),

              const SizedBox(height: 15),

              // Brand
              DropdownButtonFormField<String>(
                value: form.selectedBrand,
                decoration: const InputDecoration(labelText: "Brand"),
                items: brands
                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (value) {
                  context
                      .read<VehicleBloc>()
                      .add(SelectCreateBrandEvent(value!));
                },
              ),

              const SizedBox(height: 12),

              // Model
              DropdownButtonFormField<Model>(
                value: form.filteredModels.contains(form.selectedModel)
                    ? form.selectedModel
                    : null,
                decoration: const InputDecoration(labelText: "Model"),
                items: form.filteredModels
                    .map((m) => DropdownMenuItem(
                  value: m,
                  child: Text(m.name),
                ))
                    .toList(),
                onChanged: (m) {
                  context
                      .read<VehicleBloc>()
                      .add(SelectCreateModelEvent(m!));
                },
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        BlocBuilder<VehicleBloc, VehicleState>(
          builder: (context, state) {
            if (state is! VehicleCreateFormLoaded) {
              return const SizedBox.shrink();
            }

            final form = state;

            final plateRegex = RegExp(r'^[0-9]{4}-[A-Z]{2}$');
            final isPlateValid = plateRegex.hasMatch(form.plate);

            final isFormValid = isPlateValid &&
                form.year != null &&
                form.year!.isNotEmpty && // Verificar que no esté vacío
                form.selectedModel != null;

            return ElevatedButton(
              onPressed: !isFormValid
                  ? null
                  : () {
                final request = VehicleCreateRequest(
                  plate: form.plate,
                  year: form.year!,
                  modelId: form.selectedModel!.id,
                );

                context.read<VehicleBloc>().add(
                  CreateVehicleForOwnerIdEvent(
                    request: request,
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text("Create"),
            );
          },
        ),
      ],
    );
  }
}
