class AddTicketInputModel {
  final String title;
  final String description;
  final String location;
  final String createdDate;
  final String fileName;

  AddTicketInputModel({
    required this.title,
    required this.description,
    required this.location,
    required this.createdDate,
    required this.fileName,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'location': location,
        'dateTime': createdDate,
        'fileName': fileName,
      };
}
