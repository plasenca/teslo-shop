import 'package:flutter/services.dart';
import 'package:formz/formz.dart';

// Define input validation errors
enum PriceError { empty, value }

// Extend FormzInput and provide the input type and error type.
class Price extends FormzInput<double, PriceError> {
  // Call super.pure to represent an unmodified form input.
  const Price.pure() : super.pure(0.0);

  // Call super.dirty to represent a modified form input.
  const Price.dirty(double value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PriceError.empty) return 'El campo es requerido';
    if (displayError == PriceError.value) {
      return 'El valor debe ser un número mayor o igual 0';
    }

    return null;
  }

  List<TextInputFormatter> get inputFormatters => [
        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
      ];

  // Override validator to handle validating a given input value.
  @override
  PriceError? validator(double value) {
    final isValueTrimmedEmpty = value.toString().trim().isEmpty;

    if (value.isNaN || isValueTrimmedEmpty) return PriceError.empty;
    if (value.isNegative) return PriceError.value;

    return null;
  }
}
