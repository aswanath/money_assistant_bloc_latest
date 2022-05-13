import 'package:hive/hive.dart';
import 'package:money_assistant_final/model/model_class.dart';
import 'package:money_assistant_final/services/category_repository.dart';

import '../globalUsageValues.dart';
import '../main.dart';

class TransactionRepository {
  final transactionBox = Hive.box<Transaction>(boxTrans);
  ///get transaction box
  Box<Transaction> getTransactionBox() => transactionBox;

  ///get transaction list
  List<Transaction> getTransactionList() => transactionBox.values.toList();

  ///add transaction
  void createTransaction(Transaction transaction) =>
      transactionBox.add(transaction);

  ///get transaction
  Transaction readTransaction(int key) => transactionBox.get(key)!;

  ///edit transaction
  void updateTransaction(Transaction transaction, int key) =>
      transactionBox.put(key, transaction);

  ///delete transaction
  void deleteTransaction(int key) => transactionBox.delete(key);

  ///get period filtered list
  List<Transaction> periodFilterTransactionList(DateTime firstDate,DateTime finalDate) {
    List<Transaction> periodFilter = [];
    List<Transaction> boxList = transactionBox.values.toList();
    for (int i = 0; i < boxList.length; i++) {
      if ((boxList[i].date.isAfter(firstDate) ||
          dateFormatterPeriod.format(boxList[i].date) ==
              dateFormatterPeriod.format(firstDate)) &&
          (boxList[i].date.isBefore(finalDate) ||
              dateFormatterPeriod.format(boxList[i].date) ==
                  dateFormatterPeriod.format(finalDate))) {
        periodFilter.add(boxList[i]);
      }
    }
    periodFilter.sort((b,a)=> a.date.compareTo(b.date));
    return periodFilter;
  }

  ///get monthly filtered list
  List<Transaction> monthFilterTransactionList(DateTime date) {
    List<Transaction> filteredListMonth = [];
    List<Transaction> boxList = transactionBox.values.toList();
    for (int i = 0; i < boxList.length; i++) {
      if (boxList[i].date.month == date.month && boxList[i].date.year == date.year) {
        filteredListMonth.add(boxList[i]);
      }
    }
    filteredListMonth.sort((b,a)=> a.date.compareTo(b.date));
    return filteredListMonth;
  }

  ///get yearly filtered list
  List<Transaction> yearFilterTransactionList(DateTime date) {
    List<Transaction> filteredListYear = [];
    List<Transaction> boxList = transactionBox.values.toList();
    for (int i = 0; i < boxList.length; i++) {
      if (boxList[i].date.year == date.year) {
        filteredListYear.add(boxList[i]);
      }
    }
    filteredListYear.sort((b,a)=> a.date.compareTo(b.date));
    return filteredListYear;
  }

  ///get total income
  double incomeSum(List<Transaction> list) {
    double incomeTotal = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].transactionType == true) {
        incomeTotal += list[i].amount;
      }
    }
    return incomeTotal;
  }

  ///get total expense
  double expenseSum(List<Transaction> list) {
    double expenseTotal = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].transactionType == false) {
        expenseTotal += list[i].amount;
      }
    }
    return expenseTotal;
  }

  ///transaction check
  bool checkTransaction(int key) {
    String _name = CategoryRepository().getCategory(key).categoryName;
    List<Transaction> check = transactionBox.values
        .where((element) => element.category.contains(_name))
        .toList();
    return check.isEmpty ? false : true;
  }

  ///transaction box clear
  void transactionBoxClear() => transactionBox.clear();

}
