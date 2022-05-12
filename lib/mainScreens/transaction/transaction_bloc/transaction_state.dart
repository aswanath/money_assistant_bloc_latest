part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState {}

class TransactionFiltered extends TransactionState {
  final List<Transaction> list;
  final double incomeAmount;
  final double expenseAmount;
  TransactionFiltered({required this.list,required this.incomeAmount,required this.expenseAmount});
}

class TransactionFilteredEmpty extends TransactionState{}