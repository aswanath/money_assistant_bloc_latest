import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_assistant_final/mainScreens/category/category_bloc_logic/category_bloc.dart';
import 'package:money_assistant_final/mainScreens/transaction/date_change_cubit/change_date_cubit.dart';
import 'package:money_assistant_final/services/transactions_repository.dart';

import '../../../model/model_class.dart';
import '../../../notification.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;
  late StreamSubscription changeDateStream;
  final ChangeDateCubit changeDateCubit;
  late StreamSubscription categoryStream;
  final CategoryBloc categoryBloc;

  TransactionBloc(
      {required this.transactionRepository, required this.changeDateCubit,required this.categoryBloc})
      : super(transactionRepository
      .monthFilterTransactionList(DateTime.now()).isEmpty?TransactionFilteredEmpty():TransactionFiltered(
            list: transactionRepository
                .monthFilterTransactionList(DateTime.now()),
            incomeAmount: transactionRepository.incomeSum(transactionRepository
                .monthFilterTransactionList(DateTime.now())),
            expenseAmount: transactionRepository.expenseSum(
                transactionRepository
                    .monthFilterTransactionList(DateTime.now())))) {
    changeDateStream =
        changeDateCubit.stream.asBroadcastStream().listen((state) {
      if (state is ChangeDateMonth) {
        add(TransactionMonthly(dateTime: state.dateTime));
      } else if (state is ChangeDateYear) {
        add(TransactionYearly(dateTime: state.dateTime));
      } else if (state is ChangeDatePeriod) {
        add(TransactionPeriod(
            firstDate: state.firstDate, finalDate: state.finalDate));
      }
    });

    categoryStream = categoryBloc.stream.asBroadcastStream().listen((state) {
      print("listening");
      if(state is CategoryClearBox){
        add(TransactionMonthly(dateTime: DateTime.now()));
      }else if(state is CategoryUpdateSuccess){
        add(TransactionMonthly(dateTime: DateTime.now()));
      }
    });

    on<TransactionEvent>((event, emit) {
      if (event is TransactionMonthly) {
        List<Transaction> list =
            transactionRepository.monthFilterTransactionList(event.dateTime);
        if (list.isEmpty) {
          emit(TransactionFilteredEmpty());
        } else {
          double incomeAmount = transactionRepository.incomeSum(list);
          double expenseAmount = transactionRepository.expenseSum(list);
          emit(TransactionFiltered(
              list: list,
              incomeAmount: incomeAmount,
              expenseAmount: expenseAmount));
        }
      }

      if (event is TransactionYearly) {
        List<Transaction> list =
            transactionRepository.yearFilterTransactionList(event.dateTime);
        if (list.isEmpty) {
          emit(TransactionFilteredEmpty());
        } else {
          double incomeAmount = transactionRepository.incomeSum(list);
          double expenseAmount = transactionRepository.expenseSum(list);
          emit(TransactionFiltered(
              list: list,
              incomeAmount: incomeAmount,
              expenseAmount: expenseAmount));
        }
      }

      if (event is TransactionPeriod) {
        List<Transaction> list = transactionRepository
            .periodFilterTransactionList(event.firstDate, event.finalDate);
        if (list.isEmpty) {
          emit(TransactionFilteredEmpty());
        } else {
          double incomeAmount = transactionRepository.incomeSum(list);
          double expenseAmount = transactionRepository.expenseSum(list);
          emit(TransactionFiltered(
              list: list,
              incomeAmount: incomeAmount,
              expenseAmount: expenseAmount));
        }
      }

      if (event is TransactionFieldEmpty) {
        emit(TransactionFieldEmptyState());
      }

      if (event is TransactionAdded) {
        transactionRepository.createTransaction(event.transaction);
        createPersistentNotification();
        emit(TransactionAddedSuccess());
      }

      if (event is TransactionContinue) {
        transactionRepository.createTransaction(event.transaction);
        createPersistentNotification();
        emit(TransactionContinueSuccess());
      }

      if (event is TransactionUpdate) {
        transactionRepository.updateTransaction(event.transaction, event.key);
        createPersistentNotification();
        emit(TransactionUpdateSuccess());
      }

      if (event is TransactionDelete) {
        transactionRepository.deleteTransaction(event.key);
        createPersistentNotification();
        emit(TransactionUpdateSuccess());
      }

      if (event is TransactionSearchEvent) {
        List<Transaction> list = [];
        if (event.popupItem == 'Monthly') {
          list =
              transactionRepository.monthFilterTransactionList(event.firstDate);
        } else if (event.popupItem == 'Yearly') {
          list =
              transactionRepository.yearFilterTransactionList(event.firstDate);
        } else if (event.popupItem == 'Period') {
          list = transactionRepository.periodFilterTransactionList(
              event.firstDate, event.secondDate!);
        }
        List<Transaction> newTransactionList = list.where((element) {
          if (element.category
              .toLowerCase()
              .contains(event.searchString.toLowerCase())) {
            return element.category
                .toLowerCase()
                .contains(event.searchString.toLowerCase());
          } else {
            return element.notes
                .toLowerCase()
                .contains(event.searchString.toLowerCase());
          }
        }).toList();
        double incomeAmount =
            transactionRepository.incomeSum(newTransactionList);
        double expenseAmount =
            transactionRepository.expenseSum(newTransactionList);
        emit(TransactionFiltered(
            list: newTransactionList,
            incomeAmount: incomeAmount,
            expenseAmount: expenseAmount));
      }

      if (event is TransactionFilterEvent) {
        List<Transaction> list = [];
        if (event.popupItem == 'Monthly') {
          list =
              transactionRepository.monthFilterTransactionList(event.firstDate);
          emit(TransactionFiltered(
              list: list,
              incomeAmount: transactionRepository.incomeSum(list),
              expenseAmount: transactionRepository.expenseSum(list)));
        } else if (event.popupItem == 'Yearly') {
          list =
              transactionRepository.yearFilterTransactionList(event.firstDate);
          emit(TransactionFiltered(
              list: list,
              incomeAmount: transactionRepository.incomeSum(list),
              expenseAmount: transactionRepository.expenseSum(list)));
        } else if (event.popupItem == 'Period') {
          list = transactionRepository.periodFilterTransactionList(
              event.firstDate, event.secondDate!);
          emit(TransactionFiltered(
              list: list,
              incomeAmount: transactionRepository.incomeSum(list),
              expenseAmount: transactionRepository.expenseSum(list)));
        }
      }


    });
  }

  @override
  Future<void> close() {
    changeDateStream.cancel();
    categoryStream.cancel();
    return super.close();
  }

}
