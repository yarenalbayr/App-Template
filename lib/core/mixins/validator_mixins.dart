mixin ValidatorsMixins {
  String? lenghtHasToBeAtLeast(int lenght, String? value, [String? message]) {
    final text = message ?? 'Must contain at least $lenght characters';
    if (value == null) return text;
    if (value.length < lenght) return text;

    return null;
  }

  String? isNotEmpty(String? value, [String? message]) {
    final isValueEmpty = value?.replaceAll(' ', '').isEmpty ?? true;
    if (isValueEmpty) return message ?? 'Required';
    return null;
  }

  String? isValidEmail(String? value, [String? message]) {
    final text = message ?? 'Invalid e-mail';
    if (value == null) return text;
    final isEmailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value);

    if (isEmailValid == false) return text;
    return null;
  }

  String? needsToMatchRegex(RegExp? regex, String? value, [String? message]) {
    if (value == null || regex == null) return message ?? 'Invalid text';
    final lenght = regex.allMatches(value).length;
    final isValid = lenght >= 1;
    if (isValid == false) return message ?? 'Invalid text';

    return null;
  }

  String? cantMatchRegex(RegExp regex, String? value, [String? message]) {
    if (value == null) return message ?? 'Invalid text';
    final lenght = regex.allMatches(value).length;
    final isValid = lenght >= 1;
    if (isValid == true) return message ?? 'Invalid text';

    return null;
  }

  String? needsToBeAValidRegex(
    String? stringThatNeedsToBeAValidRegex, [
    String? message,
  ]) {
    final errorText = message ?? 'Typed text is a invalid regular expression';
    if (stringThatNeedsToBeAValidRegex == null) return errorText;

    try {
      // Will throw a [FormatException] if is a invalid string
      final _ = RegExp(stringThatNeedsToBeAValidRegex, multiLine: true);
    } catch (_) {
      return errorText;
    }

    return null;
  }

  String? combineValidators(List<String? Function()> validators) {
    for (final func in validators) {
      final validation = func();
      if (validation != null) return validation;
    }

    return null;
  }

  String? combineValidatorsWithParser(
    String? Function() valueParsed,
    List<String? Function()> Function(String? value) validators,
  ) {
    final list = validators(valueParsed());
    for (final func in list) {
      final validation = func();
      if (validation != null) return validation;
    }

    return null;
  }

  String? isValidPhone(
    String? value,
  ) {
    const patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    if (value == null) return 'Required';

    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!RegExp(patttern).hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? custom(String? Function() validator) {
    return validator();
  }
}
