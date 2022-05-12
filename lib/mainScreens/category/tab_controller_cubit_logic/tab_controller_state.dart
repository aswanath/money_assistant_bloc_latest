part of 'tab_controller_cubit.dart';

abstract class TabControllerState extends Equatable {
  const TabControllerState();
}

class TabControllerChange extends TabControllerState {
  final Color color;
  const TabControllerChange({required this.color});
  @override
  List<Object> get props => [color];
}
