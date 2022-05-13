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

class TransactionFieldEmpty extends TransactionEvent{}

class TransactionAdded extends TransactionEvent{
  final Transaction transaction;
  TransactionAdded({required this.transaction});
}

class TransactionContinue extends TransactionEvent{
  final Transaction transaction;
  TransactionContinue({required this.transaction});
}

class TransactionUpdate extends TransactionEvent{
  final Transaction transaction;
  final int key;
  TransactionUpdate({required this.transaction,required this.key});
}

class TransactionDelete extends TransactionEvent{
  final int key;
  TransactionDelete({required this.key});
}

class TransactionSearchEvent extends TransactionEvent{
  final String searchString;
  final String popupItem;
  final DateTime firstDate;
  final DateTime? secondDate;
  TransactionSearchEvent({required this.searchString,required this.popupItem,required this.firstDate,this.secondDate});
}

// class TransactionBudgetAmount extends TransactionEvent{
//   final String popupItem;
//   final DateTime firstDate;
//   final DateTime secondDate;
//   TransactionBudgetAmount({required this.popupItem,required this.firstDate,required this.secondDate});
// }

class TransactionFilterEvent extends TransactionEvent{
  final String popupItem;
  final DateTime firstDate;
  final DateTime? secondDate;
  TransactionFilterEvent({required this.popupItem,required this.firstDate,this.secondDate});
}