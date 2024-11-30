import 'package:flutter/material.dart';
import 'package:hyper_market/core/utils/constants/colors.dart';

class CustomCheckBox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CustomCheckBox({
    Key? key,
    this.initialValue = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(10, -12), // Move the checkbox to the right
      child: Transform.scale(
        scale: 1.4, // Increase the size of the checkbox
        child: Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value ?? false;
              widget.onChanged(isChecked); // Notify the parent widget
            });
          },
          side: BorderSide(
            width: 1,
            color: TColors.darkGrey.withOpacity(0.5),
          ),
          activeColor: TColors.primary, // Color when checked
        ),
      ),
    );
  }
}
