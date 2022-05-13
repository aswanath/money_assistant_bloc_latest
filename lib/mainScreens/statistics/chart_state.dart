part of 'chart_cubit.dart';

@immutable
abstract class ChartState {}

class ChartChangeState extends ChartState {}

class ChartStatisticsChangeState extends ChartState {
  final List<GDPData> incomeTransaction;
  final List<GDPData> expenseTransaction;
   ChartStatisticsChangeState({required this.expenseTransaction,required this.incomeTransaction});
}