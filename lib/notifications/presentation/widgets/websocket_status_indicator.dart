// widgets/websocket_status_indicator.dart
import 'package:flutter/material.dart';

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
                ? 'Connected - Receiving alerts in real time ${vehicleId != null ? 'for the vehicle $vehicleId' : ''}'
                : 'Disconnected - Real-time alerts are unavailable',
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