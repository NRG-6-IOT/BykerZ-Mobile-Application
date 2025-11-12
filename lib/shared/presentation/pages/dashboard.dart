import 'package:byker_z_mobile/shared/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: const AppDrawer(),

      body: PopScope(
        canPop: false,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                  'Dashboard Page',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
