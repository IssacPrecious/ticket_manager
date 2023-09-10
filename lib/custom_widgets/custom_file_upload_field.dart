import 'package:flutter/material.dart';

class CustomFilePicker extends StatelessWidget {
  const CustomFilePicker({
    super.key,
    required this.labelText,
    required this.onPress,
    required this.controller,
    this.hintText = 'Upload Screenshot',
  });

  final String labelText;
  final void Function()? onPress;
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelText, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextFormField(
              controller: controller,
              cursorColor: Colors.transparent,
              cursorWidth: 0.0,
              onTap: onPress,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
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
                prefixIcon: Icon(Icons.upload_file),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
