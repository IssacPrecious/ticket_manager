import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ticket_manager/utils/form_validators.dart';

class CustomTextFormFleld extends StatelessWidget {
  const CustomTextFormFleld({
    super.key,
    required this.label,
    required this.hintText,
    this.maxLength,
    required this.controller,
    this.maxLines = 1,
    this.validator,
    this.isEnabled,
  });

  final String label;
  final String hintText;
  final int? maxLength;
  final int? maxLines;
  final TextEditingController controller;
  final Validators? validator;
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          validator: MultiValidator(validator != null ? validator!.validations : []),
          maxLength: maxLength,
          maxLines: maxLines,
          autocorrect: true,
          controller: controller,
          enabled: isEnabled,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
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
        ),
      ],
    );
  }
}
