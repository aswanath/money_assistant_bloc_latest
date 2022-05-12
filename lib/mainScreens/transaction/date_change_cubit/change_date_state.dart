part of 'change_date_cubit.dart';

@immutable
abstract class ChangeDateState {}

class ChangeDateMonth extends ChangeDateState {
  final DateTime dateTime;
  ChangeDateMonth({required this.dateTime});
}

class ChangeDateYear extends ChangeDateState{
  final DateTime dateTime;
  ChangeDateYear({required this.dateTime});
}

class ChangeDatePeriod extends ChangeDateState{
  final DateTime firstDate;
  final DateTime finalDate;
  ChangeDatePeriod({required this.firstDate,required this.finalDate});
}