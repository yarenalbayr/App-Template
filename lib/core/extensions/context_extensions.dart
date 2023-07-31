
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension MediaQueryExtension on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
}

extension PaddingExtension on BuildContext {
  double get _lowValue => height * 0.01;
  double get _normalValue => height * 0.02;
  double get _mediumValue => height * 0.04;
  double get _highValue => height * 0.1;
  double get _horizontalValue => width * 0.04;

  EdgeInsets get paddingLow => EdgeInsets.all(_lowValue);
  EdgeInsets get paddingNormal => EdgeInsets.all(_normalValue);
  EdgeInsets get paddingMedium => EdgeInsets.all(_mediumValue);
  EdgeInsets get paddingHigh => EdgeInsets.all( _highValue);
  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: _horizontalValue);
}

extension SizedBoxExtension on BuildContext {
  double get minValue => height * 0.01;
  double get lowValue => height * 0.02;
  double get normalValue => height * 0.03;
  double get mediumValue => height * 0.04;
  double get highValue => height * 0.1;

  SizedBox get sizedBoxMin => SizedBox(height: minValue);
  SizedBox get sizedBoxLow => SizedBox(height: lowValue);
  SizedBox get sizedBoxNormal => SizedBox(height: normalValue);
  SizedBox get sizedBoxMedium => SizedBox(height: mediumValue);
  SizedBox get sizedBoxHigh => SizedBox(height: highValue);
}

extension BorderExtension on BuildContext {
  double get lowValue => 8;
  double get normalValue => 12;
  double get mediumValue => 16;
  double get highValue => 20;

  BorderRadius get borderLow => BorderRadius.circular(lowValue);
  BorderRadius get borderNormal => BorderRadius.circular(normalValue);
  BorderRadius get borderMedium => BorderRadius.circular(mediumValue);
  BorderRadius get borderHigh => BorderRadius.circular(highValue);
}

extension DateFormateExtension on BuildContext {
  DateFormat get dateFormatHourShort => DateFormat('ha');
  DateFormat get dateFormatHourLong => DateFormat('h:mma');
  DateFormat get dateFormatDayNumMonth => DateFormat('E d MMM');
  DateFormat get dateFormatDayNumMonthYear => DateFormat('EEEE, MMMM d, y');
}

class DateFormatExtension {
  final DateTime date;
  DateFormatExtension({
    required this.date,
  });

  String get dateFormatHourShort => DateFormat('ha').format(date);
  String get dateFormatHourLong => DateFormat('h:mma').format(date);
  String get dateFormatDayNumMonth => DateFormat('E d MMM').format(date);
  String get dateFormatDayNumMonthYear =>
      DateFormat('EEEE, MMMM d, y').format(date);
}
