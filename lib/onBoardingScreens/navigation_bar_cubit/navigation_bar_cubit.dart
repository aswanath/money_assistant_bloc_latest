import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_bar_state.dart';

class NavigationBarCubit extends Cubit<NavigationBarState> {
  NavigationBarCubit() : super(NavigationBarInitial(index: 0));

  void changeNavigationBar(int index) {
    emit(NavigationBarChanged(index: index));
  }
}
