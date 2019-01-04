library jalaali;

import 'package:jalaali/gregorian.dart';
import 'package:jalaali/shamsi.dart';
import 'package:jalaali/shared.dart';
import 'package:jalaali/translator.dart';

class JalaaliDate {
  /// The day of the month [1..31]
  int day;

  /// The jalaali month [1..12]
  int month;

  /// The jalaali year
  int year;

  /// Temp instance of [DateTime] used for inital convertion value
  DateTime _dateTime;

  /// Default constructor from Jalali date
  JalaaliDate(int year, int month, int day)
      : year = year,
        month = month,
        day = day;

  /// Constructs a [JalaaliDate] instance with current date
  JalaaliDate.now() {
    _dateTime = new DateTime.now();
    _convertToShamsi(_dateTime.year, _dateTime.month, _dateTime.day);
  }

  /// Constructs a [JalaaliDate] instance from a datetime
  JalaaliDate.fromDateTime(DateTime datetime) : _dateTime = datetime {
    _convertToShamsi(_dateTime.year, _dateTime.month, _dateTime.day);
  }

  /// Constructs a [JalaaliDate] instance from parsing a date string
  JalaaliDate.parse(String stringDate) {
    _dateTime = DateTime.parse(stringDate);
    _convertToShamsi(_dateTime.year, _dateTime.month, _dateTime.day);
  }

  /// Returns a human-readable string for this instance.
  String toString({
    bool showDate = true,
    bool showTime = false,
  }) {
    DateTime.now().toString();
    if (!(showDate || showTime)) {
      throw new Exception(
          'At least one of arguments [showDate or showTime] must be true');
    }
    String stringDate = '';
    if (showDate) {
      stringDate =
          year.toString() + '/' + month.toString() + '/' + day.toString();
    }
    if (showTime) {
      stringDate += ' ' +
          _dateTime.hour.toString() +
          ':' +
          _dateTime.minute.toString() +
          ':' +
          _dateTime.second.toString();
    }
    return stringDate;
  }

  /// Returns a gregorian [DateData] from current shamsi date
  DateData _toGregorian() {
    int jdn = shamsiToJdn(year, month, day);
    DateData gregorin = jdnToGregorian(jdn);
    return gregorin;
  }

  /// Returns an instance of [DateTime] from this [JalaaliDate]
  DateTime toDateTime() {
    DateData date = _toGregorian();
    return new DateTime(date.year, date.month, date.day);
  }

  /// Converts gregorian date to jalaali date and stores to this instance of [JalaaliDate]
  void _convertToShamsi(int gyear, int gmonth, int gday) {
    int jdn = gregorianToJdn(gyear, gmonth, gday);
    DateData shamsi = jdnToShamsi(jdn);
    year = shamsi.year;
    month = shamsi.month;
    day = shamsi.day;
  }

  // Returns the jalaali date in determined format
  String format(String format, {bool persianNumbers = false}) {
    DateData jDate = DateData(year, month, day);
    return translate(format, jDate, persianNumbers);
  }
}
