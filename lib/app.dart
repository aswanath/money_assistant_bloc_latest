import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_assistant_final/mainScreens/category/category_bloc_logic/category_bloc.dart';
import 'package:money_assistant_final/mainScreens/settings/settings_cubit/settings_cubit.dart';
import 'package:money_assistant_final/mainScreens/transaction/icon_cubit_logic/icon_cubit.dart';
import 'package:money_assistant_final/model/model_class.dart';
import 'package:money_assistant_final/services/category_repository.dart';
import 'package:money_assistant_final/services/chart_repository.dart';
import 'package:money_assistant_final/services/transactions_repository.dart';

import 'main.dart';
import 'onBoardingScreens/bottom_navigation_bar.dart';
import 'onBoardingScreens/navigation_bar_cubit/navigation_bar_cubit.dart';
import 'onBoardingScreens/on_boarding_one_screen.dart';

class MyApp extends StatelessWidget {
  final TransactionRepository transactionRepository;
  final CategoryRepository categoryRepository;
  const MyApp({Key? key,required this.categoryRepository,required this.transactionRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => categoryRepository),
        RepositoryProvider(create: (context) => ChartRepository()),
        RepositoryProvider(create: (context) => transactionRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context)=> NavigationBarCubit()),
          BlocProvider(create: (context)=> IconCubit()),
          BlocProvider(create: (context)=> CategoryBloc(categoryDatabase: categoryRepository, transactionDatabase: transactionRepository)),
          BlocProvider(create: (context)=> SettingsCubit()),
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
