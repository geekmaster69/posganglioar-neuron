import 'package:formz/formz.dart';

// Define input validation errors
enum DoubleInputError { empty, format }

// Extend FormzInput and provide the input type and error type.
class DoubleInput extends FormzInput<double, DoubleInputError> {



  // Call super.pure to represent an unmodified form input.
  const DoubleInput.pure() : super.pure(0.0);

  // Call super.dirty to represent a modified form input.
  const DoubleInput.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == DoubleInputError.empty ) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  DoubleInputError? validator(double value) {
    
    if ( value == 0.0) return DoubleInputError.empty;
   

    return null;
  }
}