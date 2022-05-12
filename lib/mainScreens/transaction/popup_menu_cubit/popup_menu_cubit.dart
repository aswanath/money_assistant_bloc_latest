import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'popup_menu_state.dart';

class PopupMenuCubit extends Cubit<PopupMenuState> {
  PopupMenuCubit() : super(PopupMenuChange(item: 'Monthly'));

  void changePopupMenu(String item){
     emit(PopupMenuChange(item: item));
  }
}
