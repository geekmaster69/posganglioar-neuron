import 'package:formz/formz.dart';

// Define input validation errors
enum StringInputError { empty, format }

// Extend FormzInput and provide the input type and error type.
class StringInput extends FormzInput<String, StringInputError> {



  // Call super.pure to represent an unmodified form input.
  const StringInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const StringInput.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == StringInputError.empty ) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  StringInputError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return StringInputError.empty;
   

    return null;
  }
}