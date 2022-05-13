part of 'settings_cubit.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SwitchState extends SettingsState{
  final bool isOn;
  SwitchState({required this.isOn});
}

class SwitchStateTwo extends SettingsState{}

class NotificationPermissionRequest extends SettingsState{}
