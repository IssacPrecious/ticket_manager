import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_manager/common_widgets/custom_text_form_field.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskScreenState();
}

final TextEditingController titleController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController locationController = TextEditingController();
final TextEditingController dateTimeController = TextEditingController();

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(title: Text("Add Task")),
      body: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create New Ticket ",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Form(
                  child: Column(
                children: [
                  CustomTextFormFleld(
                    label: "Title",
                    hintText: "Enter the problem title",
                    maxLength: 100,
                    controller: titleController,
                  ),
                  SizedBox(height: 16),
                  CustomTextFormFleld(
                    label: "Description",
                    hintText: "Enter the problem description",
                    maxLength: 100,
                    controller: descriptionController,
                  ),
                  SizedBox(height: 16),
                  CustomTextFormFleld(
                    label: "Location",
                    hintText: "Enter your current location",
                    maxLength: 100,
                    controller: locationController,
                  ),
                  SizedBox(height: 16),
                  CustomTextFormFleld(
                    label: "Date",
                    hintText: "Enter the current date",
                    maxLength: 100,
                    controller: dateTimeController,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () async {
                        final title = titleController.text;
                        final description = descriptionController.text;
                        final location = locationController.text;
                        final dateTime = DateTime.now();

                        await FirebaseFirestore.instance.collection('tickets').add(
                            {'title': title, 'description': description, 'location': location, 'dateTime': dateTime});
                      },
                      child: Text("Create Ticket"))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
