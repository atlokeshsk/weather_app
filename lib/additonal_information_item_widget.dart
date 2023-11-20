import 'package:flutter/material.dart';

class AdditonalInformationItem extends StatelessWidget {
  const AdditonalInformationItem(
      {super.key,
      required this.iconData,
      required this.itemType,
      required this.value});
  final IconData iconData;
  final String itemType;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 120,
      height: 120,
      child: Card(
        color: colorScheme.tertiaryContainer,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Icon(
                iconData,
                size: 30,
                color: colorScheme.onTertiaryContainer,
              ),
              const SizedBox(
                height: 10,
              ),
              FittedBox(
                child: Text(
                  itemType,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onTertiaryContainer),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                value,
                style: TextStyle(color: colorScheme.onTertiaryContainer),
              )
            ],
          ),
        ),
      ),
    );
  }
}
