part of 'navigation_bar_cubit.dart';

@immutable
abstract class NavigationBarState {}

class NavigationBarInitial extends NavigationBarState {
  final int index;
  NavigationBarInitial({required this.index});
}

class NavigationBarChanged extends NavigationBarState{
  final int index;
  NavigationBarChanged({required this.index});
}