part of 'date_change_transaction_cubit.dart';

@immutable
abstract class DateChangeTransactionState {}

class DateChangeInitial extends DateChangeTransactionState{}

class DateChangeTransaction extends DateChangeTransactionState {
  final DateTime dateTime;
  DateChangeTransaction({required this.dateTime});
}

class CategorySelectState extends DateChangeTransactionState{
  final String category;
  CategorySelectState({required this.category});
}