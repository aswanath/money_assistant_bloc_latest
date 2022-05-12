part of 'popup_menu_cubit.dart';

@immutable
abstract class PopupMenuState {}

class PopupMenuChange extends PopupMenuState {
  final String item;
  PopupMenuChange({required this.item});
}
