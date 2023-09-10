import 'package:form_field_validator/form_field_validator.dart';

class Validators {
  String fieldName;
  Validators(this.fieldName);

  List<FieldValidator<dynamic>> validations = [];

  required() {
    validations.add(RequiredValidator(errorText: "$fieldName is required"));
    return this;
  }

  min(int length) {
    validations.add(MinLengthValidator(length, errorText: "$fieldName should be atleast $length characters"));
    return this;
  }
}
