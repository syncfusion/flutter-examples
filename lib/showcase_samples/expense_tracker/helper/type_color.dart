import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class TypeColor extends StatelessWidget {
  const TypeColor({required this.type, super.key});
  final String type;

  @override
  Widget build(BuildContext context) {
    Color boxColor;
    Color textColor;

    // Set the box color and text color based on the type
    switch (type.toLowerCase()) {
      case 'income':
      case 'deposit':
      case 'low':
        boxColor = doughnutPalette(Theme.of(context))[8];
        textColor = doughnutPalette(Theme.of(context))[1];
        break;
      case 'withdraw':
      case 'expense':
      case 'high':
      case 'savings':
        boxColor = Theme.of(context).colorScheme.errorContainer;
        textColor = Theme.of(context).colorScheme.error;
        break;
      default:
        boxColor = Colors.grey; // Default color for unknown type
        textColor = Colors.black; // Default text color
        break;
    }

    return Container(
      padding: const EdgeInsets.only(
        left: 6.0,
        right: 6.0,
        top: kIsWeb ? 1.0 : 0.4,
        bottom: 1.6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: boxColor,
      ),
      child: Text(
        type,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          color: textColor,
        ),
      ),
    );
  }
}
