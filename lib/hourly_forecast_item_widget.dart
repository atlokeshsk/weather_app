import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  const HourlyForecastItem(
      {super.key,
      required this.time,
      required this.icon,
      required this.temperature});
  final String time;
  final IconData icon;
  final String temperature;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Card(
        color: colorScheme.secondaryContainer,
        elevation: 5.0,
        child: SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSecondaryContainer),
                ),
                Icon(
                  icon,
                  size: 32,
                  color: colorScheme.onSecondaryContainer,
                ),
                Text(
                  temperature,
                  style: TextStyle(color: colorScheme.onSecondaryContainer),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
