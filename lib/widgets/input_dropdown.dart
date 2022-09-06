import 'package:flutter/material.dart';

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    Key? key,
    this.labelText,
    required this.valueText,
    required this.valueStyle,
    required this.onPressed,
  }) : super(key: key);

  final String? labelText;
  final VoidCallback onPressed;
  final TextStyle valueStyle;
  final String valueText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
