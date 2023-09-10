import 'package:flutter/material.dart';

class CustomTextFormFleld extends StatelessWidget {
  const CustomTextFormFleld({
    super.key,
    required this.label,
    required this.hintText,
    required this.maxLength,
    required this.controller,
  });

  final String label;
  final String hintText;
  final int maxLength;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      maxLines: 2,
      autocorrect: true,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
        filled: true,
        fillColor: Colors.white,
        label: Text(label),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.labelLarge,
        errorStyle: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.red),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.indigo),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.indigo),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
