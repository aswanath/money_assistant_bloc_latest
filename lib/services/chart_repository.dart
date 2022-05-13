import 'package:money_assistant_final/services/transactions_repository.dart';

import '../../model/model_class.dart';
import '../mainScreens/statistics/screen_statistics.dart';
import 'category_repository.dart';

class ChartRepository {
  final _catBox = CategoryRepository().getCategoryBox();
  final TransactionRepository _transactionDatabase = TransactionRepository();

  ///get GDP income List
  List<GDPData> getGdpDataIncome(List<Transaction> transactions) {
    final List<GDPData> chartDataIncome = [];
    List<Category> catList = _catBox.values.toList();
    for (int i = 0; i < catList.length; i++) {
      double amount = 0;
      if (catList[i].transactionType == true) {
        for (int j = 0; j < transactions.length; j++) {
          if (catList[i].categoryName == transactions[j].category) {
            amount += transactions[j].amount;
          }
        }
        if (amount != 0) {
          var percentage =
          ((amount.roundToDouble() / _transactionDatabase.incomeSum(transactions)) * 100)
              .toStringAsFixed(2);
          chartDataIncome.add(GDPData(
              catList[i].categoryName, amount.round(), '$percentage %'));
        }
      }
    }
    return chartDataIncome;
  }

  ///get GDP expense List
  List<GDPData> getGdpDataExpense(List<Transaction> transactions) {
    final List<GDPData> charDataExpense = [];
    List<Category> catList = _catBox.values.toList();
    for (int i = 0; i < catList.length; i++) {
      double amount = 0;
      if (catList[i].transactionType == false) {
        for (int j = 0; j < transactions.length; j++) {
          if (catList[i].categoryName == transactions[j].category) {
            amount += transactions[j].amount;
          }
        }
        if (amount != 0) {
          var percentage =
          ((amount.roundToDouble() / _transactionDatabase.expenseSum(transactions)) * 100)
              .toStringAsFixed(2);
          charDataExpense.add(GDPData(
              catList[i].categoryName, amount.round(), '$percentage %'));
        }
      }
    }
    return charDataExpense;
  }
}
