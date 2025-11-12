import 'package:byker_z_mobile/shared/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class Expenses extends StatelessWidget {
  const Expenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
                'Expenses Page',
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
