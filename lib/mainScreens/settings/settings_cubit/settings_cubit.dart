import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../main.dart';
import '../../../notification.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial()) {
    bool isOn = prefs.getBool('notification')!;
    emit(SwitchState(isOn: isOn));
  }

  void toggleSwitchButton(bool value) {
    if (value == false) {
      AwesomeNotifications()
          .cancelAll()
          .then((_) => prefs.setBool('notification', false));
      AwesomeNotifications().resetGlobalBadge();
      emit(SwitchState(isOn: false));
    }else{
      emit(NotificationPermissionRequest());
    }
  }

  void toggleSwitchButtonTwo(){
    createPersistentNotification();
    prefs.setBool('notification', true);
    emit(  SwitchState(isOn: true));
  }

  void toggleSwitchButtonThree(){
    prefs.setBool('notification', true);
    AwesomeNotifications()
        .requestPermissionToSendNotifications()
        .then((checkAllowed) {
      createPersistentNotification();
      emit(SwitchStateTwo());
    });
  }

}

