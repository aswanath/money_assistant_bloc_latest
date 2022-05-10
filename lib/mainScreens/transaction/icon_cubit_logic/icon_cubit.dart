import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'icon_state.dart';

class IconCubit extends Cubit<IconState> {
  IconCubit() : super(IconChangeNormal());

  void changeToSearch() => emit(IconChangeSearch());
  void changeToNormal() => emit(IconChangeNormal());
}
