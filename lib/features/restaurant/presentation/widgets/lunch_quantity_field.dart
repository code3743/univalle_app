import 'package:flutter/material.dart';

class LunchQuantityField extends StatelessWidget {
  const LunchQuantityField({
    super.key,
    required this.controller,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.validator,
  });

  final TextEditingController controller;
  final int min;
  final int max;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;

  int get _current => int.tryParse(controller.text) ?? min;

  void _stepBy(int delta) {
    final next = (_current + delta).clamp(min, max);
    controller.text = next.toString();
    onChanged(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => _stepBy(-1),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _stepBy(1),
        ),
      ),
    );
  }
}
