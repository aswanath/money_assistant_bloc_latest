part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
}

///to give category income list
class CategoryIncomeState extends CategoryState {
  final List<Category> categoryList;
  const CategoryIncomeState({required this.categoryList});
  @override
  List<Category> get props => categoryList;
}

///to give category expense list
class CategoryExpenseState extends CategoryState {
  final List<Category> categoryList;
  const CategoryExpenseState({required this.categoryList});
  @override
  List<Category> get props => categoryList;
}

///category update failure
class CategoryUpdateFailure extends CategoryState{
  @override
  List<Object?> get props => [];
}

///category update success
class CategoryUpdateSuccess extends CategoryState{
  @override
  List<Object?> get props => [];
}

///category delete failure
class CategoryDeleteFailure extends CategoryState{
  @override
  List<Object?> get props => [];
}
