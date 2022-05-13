import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_assistant_final/services/category_repository.dart';
import 'package:money_assistant_final/services/transactions_repository.dart';


import '../../../model/model_class.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryDatabase;
  final TransactionRepository transactionDatabase;

  CategoryBloc({required this.categoryDatabase,required this.transactionDatabase})
      : super(CategoryIncomeState(
            categoryList: categoryDatabase.getCategoryIncomeList())) {
    on<CategoryEvent>(
      (event, emit) {
        ///category expense list show
        if (event is CategoryExpenseEvent) {
          emit(CategoryExpenseState(
              categoryList: categoryDatabase.getCategoryExpenseList()));
        }

        ///category income list show
        if (event is CategoryIncomeEvent) {
          emit(CategoryIncomeState(
              categoryList: categoryDatabase.getCategoryIncomeList()));
        }

        ///category adding
        if (event is CategoryAddEvent) {
          if (!categoryDatabase
              .categoryDuplicateCheck(event.category.categoryName)) {
            categoryDatabase.createCategory(event.category);
            emit(CategoryUpdateSuccess());
          } else {
            emit(CategoryUpdateFailure());
          }
          emit(emitCategory(event.category.transactionType));
        }

        ///category editing
        if (event is CategoryUpdateEvent) {
          if (event.newCategoryName ==
              categoryDatabase.getCategory(event.key).categoryName) {
            emit(CategoryUpdateSuccess());
          } else if (!categoryDatabase
              .categoryDuplicateCheck(event.newCategoryName)) {
            categoryDatabase.checkCategory(event.newCategoryName, event.key,transactionDatabase);
            categoryDatabase.updateCategory(
                Category(event.transactionType, event.newCategoryName),
                event.key);
            emit(CategoryUpdateSuccess());
          } else {
            emit(CategoryUpdateFailure());
          }
         emit(emitCategory(event.transactionType));
        }

        ///category deleting
        if (event is CategoryDeleteEvent) {
          bool _transactionType =
              categoryDatabase.getCategory(event.key).transactionType;
          if (!transactionDatabase.checkTransaction(event.key)) {
            categoryDatabase.deleteCategory(event.key);
          } else {
            emit(CategoryDeleteFailure());
          }
          emit(emitCategory(_transactionType));
        }

        ///category box clear
        if(event is CategoryClearBox){
          categoryDatabase.clearCategoryBox();
          transactionDatabase.transactionBoxClear();
          emit(const CategoryIncomeState(
              categoryList: []));
        }
      },
    );
  }


  CategoryState emitCategory(bool transactionType){
    if (transactionType == true) {
     return CategoryIncomeState(
          categoryList: categoryDatabase.getCategoryIncomeList());
    } else {
      return CategoryExpenseState(
          categoryList: categoryDatabase.getCategoryExpenseList());
    }
  }
}
