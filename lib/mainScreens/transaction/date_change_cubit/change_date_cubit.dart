import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_assistant_final/mainScreens/transaction/popup_menu_cubit/popup_menu_cubit.dart';

part 'change_date_state.dart';

class ChangeDateCubit extends Cubit<ChangeDateState> {
  late StreamSubscription streamSubscription;
  final PopupMenuCubit popupMenuCubit;

  ChangeDateCubit({required this.popupMenuCubit})
      : super(ChangeDateMonth(dateTime: DateTime.now())) {
    streamSubscription =
        popupMenuCubit.stream.asBroadcastStream().listen((state) {
      state as PopupMenuChange;
      if (state.item == 'Monthly') {
        emit(ChangeDateMonth(dateTime: DateTime.now()));
      } else if (state.item == 'Yearly') {
        emit(ChangeDateYear(dateTime: DateTime.now()));
      } else {
        emit(ChangeDatePeriod(
            firstDate: DateTime.now(), finalDate: DateTime.now()));
      }
    });
  }

  void incrementMonth(DateTime dateTime) => emit(
      ChangeDateMonth(dateTime: DateTime(dateTime.year, dateTime.month + 1)));

  void decrementMonth(DateTime dateTime) => emit(
      ChangeDateMonth(dateTime: DateTime(dateTime.year, dateTime.month - 1)));

  void incrementYear(DateTime dateTime) =>
      emit(ChangeDateYear(dateTime: DateTime(dateTime.year + 1)));

  void decrementYear(DateTime dateTime) =>
      emit(ChangeDateYear(dateTime: DateTime(dateTime.year - 1)));

  void changeDatePeriod(DateTime firstDate, DateTime finalDate, bool isFirst) {
    if (isFirst && firstDate.isAfter(finalDate)) {
      emit(ChangeDatePeriod(firstDate: firstDate, finalDate: firstDate));
    } else if (finalDate.isBefore(firstDate)) {
      emit(ChangeDatePeriod(firstDate: finalDate, finalDate: finalDate));
    } else {
      emit(ChangeDatePeriod(firstDate: firstDate, finalDate: finalDate));
    }
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
