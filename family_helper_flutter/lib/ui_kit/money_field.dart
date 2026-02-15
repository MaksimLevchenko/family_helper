import 'package:flutter/material.dart';

import 'app_text_field.dart';

class MoneyField extends StatelessWidget {
  const MoneyField({
    super.key,
    required this.controller,
    this.label = 'Amount (cents)',
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      keyboardType: TextInputType.number,
    );
  }
}
