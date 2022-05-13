import 'package:hive/hive.dart';
import 'package:money_assistant_final/model/model_class.dart';
import 'package:money_assistant_final/services/transactions_repository.dart';

import '../main.dart';

class CategoryRepository {
  final categoryBox = Hive.box<Category>(boxCat);
  final TransactionRepository _transactionDatabase = TransactionRepository();
  ///get category box
  Box<Category> getCategoryBox() => categoryBox;

  ///get category list
  List<Category> getCategoryList() => categoryBox.values.toList();

  ///add category
  void createCategory(Category category) => categoryBox.add(category);

  ///get category
  Category getCategory(int key) => categoryBox.get(key)!;

  ///edit category
  void updateCategory(Category category, int key) =>
      categoryBox.put(key, category);

  ///delete category
  void deleteCategory(int key) => categoryBox.delete(key);

  ///income category list
  List<Category> getCategoryIncomeList() {
    List<Category> _list = categoryBox.values.toList();
    List<Category> incomeList = [];
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].transactionType == true) {
        incomeList.add(_list[i]);
      }
    }
    return incomeList;
  }

  ///expense category list
  List<Category> getCategoryExpenseList() {
    List<Category> _list = categoryBox.values.toList();
    List<Category> expenseList = [];
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].transactionType == false) {
        expenseList.add(_list[i]);
      }
    }
    return expenseList;
  }

  ///category duplicate check
  bool categoryDuplicateCheck(String text) {
    List<Category> _list = getCategoryList();
    bool check = false;
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].categoryName.trim() == text.trim()) {
        check = true;
        break;
      }
    }
    return check;
  }

  ///category update in transaction
  void checkCategory(String newName, int key,TransactionRepository transactionRepository) {
    String _name = getCategory(key).categoryName;
    print(_name);
    print(newName);
    final List<Transaction> _list = transactionRepository.getTransactionList();

    for (int i = 0; i < _list.length; i++) {
      if (_list[i].category == _name) {
        transactionRepository.updateTransaction(
            Transaction(_list[i].transactionType, _list[i].date, newName,
                _list[i].amount, _list[i].notes),
            _list[i].key);
      }
    }
  }

  ///category box clear
  void clearCategoryBox() => categoryBox.clear();
}
