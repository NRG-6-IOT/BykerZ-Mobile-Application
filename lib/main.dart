import 'package:byker_z_mobile/iam/bloc/authentication/authentication_bloc.dart';
import 'package:byker_z_mobile/iam/presentation/views/sign-in.page.dart';
import 'package:byker_z_mobile/iam/services/authentication_service.dart';
import 'package:byker_z_mobile/iam/services/profile_service.dart';
import 'package:byker_z_mobile/vehicle_wellness/data/datasource/wellness_metric_datasource.dart';
import 'package:byker_z_mobile/vehicle_wellness/data/repository/wellness_metric_repository_impl.dart';
import 'package:byker_z_mobile/vehicle_wellness/domain/usecases/CreateWellnessMetricUseCase.dart';
import 'package:byker_z_mobile/vehicle_wellness/domain/usecases/DeleteWellnessMetricUseCase.dart';
import 'package:byker_z_mobile/vehicle_wellness/domain/usecases/GetWellnessMetricByIdUseCase.dart';
import 'package:byker_z_mobile/vehicle_wellness/domain/usecases/GetWellnessMetricsByVehicleIdUseCase.dart';
import 'package:byker_z_mobile/vehicle_wellness/domain/usecases/UpdateWellnessMetricUseCase.dart';
import 'package:byker_z_mobile/vehicle_wellness/presentation/statemanagement/bloc/wellness_metric_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final dataSource = WellnessMetricDataSource();


    final repository = WellnessMetricRepositoryImpl(dataSource: dataSource);


    final createUseCase = CreateWellnessMetricUseCase(repository);
    final updateUseCase = UpdateWellnessMetricUseCase(repository);
    final deleteUseCase = DeleteWellnessMetricUseCase(repository);
    final getByIdUseCase = GetWellnessMetricByIdUseCase(repository);
    final getByVehicleIdUseCase = GetWellnessMetricsByVehicleIdUseCase(repository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthenticationBloc(
            authenticationService: AuthenticationService(),
            profileService: ProfileService()
          )
        ),
        BlocProvider(
          create: (_) => WellnessMetricBloc(
            createWellnessMetric: createUseCase,
            updateWellnessMetric: updateUseCase,
            deleteWellnessMetric: deleteUseCase,
            getWellnessMetricById: getByIdUseCase,
            getWellnessMetricsByVehicleId: getByVehicleIdUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'BykerZ',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
          home: SignInPage(),
      )
    );
  }
}
