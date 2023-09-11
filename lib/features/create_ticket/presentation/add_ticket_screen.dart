import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:ticket_manager/custom_widgets/custom_loader.dart';
import 'package:ticket_manager/custom_widgets/custom_text_form_field.dart';
import 'package:ticket_manager/custom_widgets/custom_file_upload_field.dart';
import 'package:ticket_manager/features/create_ticket/domain/add_ticket_input_model.dart';
import 'package:ticket_manager/utils/form_validators.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final GlobalKey<FormState> createTicketFormKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController screenshotController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    dateTimeController.text = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(title: const Text("Add Ticket")),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create New Ticket ",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 16),
                Form(
                  key: createTicketFormKey,
                  child: Column(
                    children: [
                      CustomTextFormFleld(
                        label: "Title *",
                        hintText: "Enter the problem title",
                        maxLength: 100,
                        controller: titleController,
                        validator: Validators("Title").required().min(3),
                      ),
                      CustomTextFormFleld(
                        label: "Description *",
                        hintText: "Enter the problem description",
                        maxLength: 240,
                        maxLines: 3,
                        controller: descriptionController,
                        validator: Validators("Description").required(),
                      ),
                      CustomTextFormFleld(
                        label: "Location *",
                        hintText: "Enter your current location",
                        maxLength: 100,
                        controller: locationController,
                        validator: Validators("Location").required(),
                      ),
                      CustomTextFormFleld(
                        label: "Reported Date *",
                        hintText: "Enter the current date",
                        controller: dateTimeController,
                        isEnabled: false,
                      ),
                      const SizedBox(height: 16),
                      CustomFilePicker(
                          labelText: "Upload Screenshot (Optional)",
                          onPress: () async {
                            CustomLoader.show(context);
                            String fileName = await imgFromGallery();
                            setState(() {
                              screenshotController.text = fileName;
                            });
                            CustomLoader.hide(context);
                          },
                          controller: screenshotController),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                          ),
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (createTicketFormKey.currentState!.validate()) {
                              AddTicketInputModel inputModel = AddTicketInputModel(
                                title: titleController.text,
                                description: descriptionController.text,
                                location: locationController.text,
                                createdDate: dateTimeController.text,
                                fileName: screenshotController.text,
                              );

                              await FirebaseFirestore.instance.collection('tickets').add(inputModel.toJson());
                            } else {
                              debugPrint("Validation Error");
                            }
                          },
                          child: Text(
                            "Create Ticket",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future<String> imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      final result = await uploadFile();
      return result;
    } else {
      debugPrint('No image selected.');
      return "";
    }
  }

  Future<String> uploadFile() async {
    if (_photo == null) return "Error selecting file..";
    final fileName = basename(_photo!.path);
    debugPrint('File Uploaded :: ' + fileName);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(_photo!);
      return fileName;
    } catch (e) {
      debugPrint('error occured');
      return "Error Uploading file..";
    }
  }
}
