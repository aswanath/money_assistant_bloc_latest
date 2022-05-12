import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../globalUsageValues.dart';

part 'tab_controller_state.dart';

class TabControllerCubit extends Cubit<TabControllerState> {
  TabControllerCubit() : super(TabControllerChange(color: incomeBlue));

  void changeColor(int tab) {
    if(tab == 1){
      emit(TabControllerChange(color: expenseRed));
    }else{
      emit(TabControllerChange(color: incomeBlue));
    }
  }
}
