import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_assistant_final/mainScreens/transaction/icon_cubit_logic/icon_cubit.dart';
import 'package:money_assistant_final/services/category_repository.dart';
import 'package:money_assistant_final/services/chart_repository.dart';
import 'package:money_assistant_final/services/transactions_repository.dart';

import 'main.dart';
import 'onBoardingScreens/bottom_navigation_bar.dart';
import 'onBoardingScreens/navigation_bar_cubit/navigation_bar_cubit.dart';
import 'onBoardingScreens/on_boarding_one_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => ChartRepository()),
        RepositoryProvider(create: (context) => TransactionRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context)=> NavigationBarCubit()),
          BlocProvider(create: (context)=> IconCubit()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
          ),
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          home: prefs.getBool('isViewed') == true
              ? const NavigationBarScreen()
              : const ScreenOnboardingOne(),
        ),
      ),
    );
  }
}
