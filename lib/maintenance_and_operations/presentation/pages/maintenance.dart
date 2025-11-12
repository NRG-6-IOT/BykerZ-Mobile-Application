import 'package:byker_z_mobile/shared/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance'),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
                'Maintenance Page',
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
