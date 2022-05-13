import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_assistant_final/mainScreens/statistics/screen_statistics.dart';
import 'package:money_assistant_final/mainScreens/transaction/transaction_bloc/transaction_bloc.dart';
import 'package:money_assistant_final/services/chart_repository.dart';
import 'package:money_assistant_final/services/transactions_repository.dart';

part 'chart_state.dart';


class ChartCubit extends Cubit<ChartState> {
  late StreamSubscription streamSubscription;
  final TransactionBloc transactionBloc;
  final ChartRepository chartDatabase;
  final TransactionRepository transactionRepository;

  ChartCubit(
      {required this.transactionBloc,
      required this.chartDatabase,
      required this.transactionRepository})
      : super(ChartStatisticsChangeState(
            incomeTransaction: chartDatabase.getGdpDataIncome(transactionRepository
                .monthFilterTransactionList(DateTime.now())),
            expenseTransaction: chartDatabase.getGdpDataExpense(transactionRepository
                .monthFilterTransactionList(DateTime.now())))) {
    streamSubscription = transactionBloc.stream.listen((state) {
      if (state is TransactionFiltered) {
        List<GDPData> incomeList = chartDatabase.getGdpDataIncome(state.list);
        List<GDPData> expenseList = chartDatabase.getGdpDataExpense(state.list);
        emit(ChartStatisticsChangeState(
            expenseTransaction: expenseList,
            incomeTransaction: incomeList,));
      }else if(state is TransactionFilteredEmpty){
        emit(ChartStatisticsChangeState(expenseTransaction: const [], incomeTransaction: const []));
      }
    });
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
