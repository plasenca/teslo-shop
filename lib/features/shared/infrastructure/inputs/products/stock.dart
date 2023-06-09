import 'package:flutter/services.dart';
import 'package:formz/formz.dart';

// Define input validation errors
enum StockError { empty, value, format }

// Extend FormzInput and provide the input type and error type.
class Stock extends FormzInput<int, StockError> {
  // Call super.pure to represent an unmodified form input.
  const Stock.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const Stock.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == StockError.empty) return 'El campo es requerido';
    if (displayError == StockError.value) {
      return 'El valor debe ser un número mayor o igual 0';
    }
    if (displayError == StockError.format) return 'No tiene formato número';

    return null;
  }

  List<TextInputFormatter> get inputFormatters => [
        FilteringTextInputFormatter.digitsOnly,
      ];

  // Override validator to handle validating a given input value.
  @override
  StockError? validator(int value) {
    final isValueTrimmedEmpty = value.toString().trim().isEmpty;

    if (value.isNaN || isValueTrimmedEmpty) return StockError.empty;
    if (value.isNegative) return StockError.value;

    return null;
  }
}
