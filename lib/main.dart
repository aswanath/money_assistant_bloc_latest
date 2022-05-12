import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_assistant_final/services/category_repository.dart';
import 'package:money_assistant_final/services/transactions_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'model/model_class.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/services.dart';


const boxCat = 'category_box';
const boxTrans = 'transaction_box';
late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Category>(boxCat);
  await Hive.openBox<Transaction>(boxTrans);
  prefs = await SharedPreferences.getInstance();
  AwesomeNotifications().initialize(
    'resource://drawable/res_splash',
    [
      NotificationChannel(
        playSound: false,
        enableVibration: false,
        icon: 'resource://drawable/res_splash',
        channelKey: 'persistent_notification',
        channelName: 'Persistent Notification',
        channelDescription: 'Showing permanent notification',
        importance: NotificationImportance.Max,
        channelShowBadge: true,
      )
    ],
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp( MyApp(transactionRepository: TransactionRepository(), categoryRepository: CategoryRepository(),));
}
