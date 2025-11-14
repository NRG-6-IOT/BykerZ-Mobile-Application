import 'package:byker_z_mobile/shared/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class Monitoring extends StatelessWidget {
  const Monitoring({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          children: [
            Text(
                'Monitoring Page',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )
            ),
          ],
        ),
      ),
    );
  }
}
