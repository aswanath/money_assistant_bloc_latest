part of 'category_bloc.dart';

abstract class CategoryEvent  {
  const CategoryEvent();
}

///to get income category list
class CategoryIncomeEvent extends CategoryEvent{}

///to get expense category list
class CategoryExpenseEvent extends CategoryEvent{}

///to add category event
class CategoryAddEvent extends CategoryEvent{
  final Category category;
  CategoryAddEvent({required this.category});
}

///to edit or add category event - success
class CategoryUpdateEvent extends CategoryEvent{
  final bool transactionType;
  final int key;
  final String newCategoryName;
  CategoryUpdateEvent({required this.transactionType,required this.key,required this.newCategoryName});
}

///to edit or add category event - failure
class CategoryUpdateEventFailure extends CategoryEvent{}

///to delete category event
class CategoryDeleteEvent extends CategoryEvent{
  final int key;
  CategoryDeleteEvent({required this.key});
}

///to clear the box
class CategoryClearBox extends CategoryEvent{}