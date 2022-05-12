import 'package:bloc/bloc.dart';

part 'icon_state.dart';

class IconCubit extends Cubit<IconState> {
  IconCubit() : super(IconChangeNormal());

  void changeToSearch() => emit(IconChangeSearch());
  void changeToNormal() => emit(IconChangeNormal());
}
