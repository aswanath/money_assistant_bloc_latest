part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class TransactionMonthly extends TransactionEvent{
  final DateTime dateTime;
  TransactionMonthly({required this.dateTime});
}

class TransactionYearly extends TransactionEvent{
  final DateTime dateTime;
  TransactionYearly({required this.dateTime});
}

class TransactionPeriod extends TransactionEvent{
  final DateTime firstDate;
  final DateTime finalDate;
  TransactionPeriod({required this.firstDate,required this.finalDate});
}