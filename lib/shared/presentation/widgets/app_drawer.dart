import 'package:byker_z_mobile/maintenance_and_operations/presentation/pages/expenses.dart';
import 'package:byker_z_mobile/maintenance_and_operations/presentation/pages/maintenance.dart';
import 'package:byker_z_mobile/shared/presentation/pages/dashboard.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/pages/vehicles.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).pop();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFF6B35),
            ),
            child: Text(
              'BykerZ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => navigateTo(context, const Dashboard()),
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('Maintenance'),
            onTap: () => navigateTo(context, const Maintenance()),
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text('Expenses'),
            onTap: () => navigateTo(context, const Expenses()),
          ),
          ListTile(
            leading: const Icon(Icons.two_wheeler),
            title: const Text('Vehicles'),
            onTap: () => navigateTo(context, const Vehicles()),
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.of(context).pop();
              // TO-DO: Implementar lógica de cierre de sesión
            },
          ),
        ],
      ),
    );
  }
}
