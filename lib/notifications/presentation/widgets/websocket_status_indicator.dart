// widgets/websocket_status_indicator.dart
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class WebSocketStatusIndicator extends StatelessWidget {
  final bool isConnected;
  final int? vehicleId;

  const WebSocketStatusIndicator({
    super.key,
    required this.isConnected,
    this.vehicleId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isConnected ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.circle,
            color: isConnected ? Colors.green : Colors.grey,
            size: 12,
          ),
          const SizedBox(width: 8),
          Text(
            isConnected
                ? '${l10n.connectedReceivingAlerts} ${vehicleId != null ? '${l10n.forVehicle} $vehicleId' : ''}'
                : l10n.disconnectedAlertsUnavailable,
            style: TextStyle(
              color: isConnected ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}