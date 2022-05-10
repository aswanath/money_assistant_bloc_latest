import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/globalUsageValues.dart';
import 'package:money_assistant_final/iconFont/my_flutter_app_icons.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:money_assistant_final/mainScreens/screen_category.dart';
import 'package:money_assistant_final/mainScreens/screen_settings.dart';
import 'package:money_assistant_final/mainScreens/screen_statistics.dart';
import 'package:money_assistant_final/mainScreens/transaction/screen_transactions.dart';
import 'package:money_assistant_final/subScreens/add_category_screen.dart';
import 'package:money_assistant_final/subScreens/add_transaction_screen.dart';

import '../main.dart';
import '../notification.dart';
import 'navigation_bar_cubit/navigation_bar_cubit.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen>
    with TickerProviderStateMixin {
  int indexNav = 0;
  final List<Widget> _pageList = [
    const TransactionsPage(),
    const StatisticsPage(),
    const CategoryPage(),
    const SettingsPage(),
  ];
  final PageController pageController = PageController();

  @override
  void initState() {
    if (prefs.getBool('notification')!) {
      createPersistentNotification();
    }
    AwesomeNotifications().displayedStream.listen((event) async {
      if (event.id == 0) {
        await AwesomeNotifications().resetGlobalBadge();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: BlocBuilder<NavigationBarCubit, NavigationBarState>(
          builder: (context, state) {
            if (state is NavigationBarChanged) {
              indexNav = state.index;
            }
            return FloatingNavbar(
                margin: EdgeInsets.fromLTRB(deviceWidth * .02, 0,
                    deviceWidth * .02, deviceWidth * .025),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                borderRadius: 15,
                backgroundColor: secondaryPurple,
                selectedItemColor: commonWhite,
                selectedBackgroundColor: null,
                items: [
                  FloatingNavbarItem(
                    customWidget: NavBarItem(
                      indexNav: indexNav,
                      iconData: MyFlutterApp.book,
                      text: 'Transactions',
                      indexOfItem: 0,
                    ),
                  ),
                  FloatingNavbarItem(
                    customWidget: NavBarItem(
                      indexNav: indexNav,
                      iconData: MyFlutterApp.chart_pie,
                      text: 'Statistics',
                      indexOfItem: 1,
                    ),
                  ),
                  FloatingNavbarItem(
                    customWidget: NavBarItem(
                      indexNav: indexNav,
                      iconData: MyFlutterApp.boxes,
                      text: 'Category',
                      indexOfItem: 2,
                    ),
                  ),
                  FloatingNavbarItem(
                    customWidget: NavBarItem(
                      indexNav: indexNav,
                      iconData: MyFlutterApp.cog,
                      text: 'Settings',
                      indexOfItem: 3,
                    ),
                  ),
                ],
                currentIndex: indexNav,
                onTap: (val) {
                  pageController.animateToPage(val,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.decelerate);
                });
          },
        ),
      ),
      backgroundColor: commonWhite,
      body: PageView(
        scrollBehavior: MyBehavior(),
        padEnds: false,
        onPageChanged: (val) {
          context.read<NavigationBarCubit>().changeNavigationBar(val);
        },
        controller: pageController,
        children: _pageList,
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final int indexNav;
  final IconData iconData;
  final String text;
  final int indexOfItem;

  const NavBarItem(
      {Key? key,
      required this.indexNav,
      required this.iconData,
      required this.text,
      required this.indexOfItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          iconData,
          color: commonWhite,
          size: 22,
        ),
        const SizedBox(
          height: 2,
        ),
        Visibility(
          child: FittedBox(
            child: CustomText(
                textData: text, textSize: 10, textColor: commonWhite),
          ),
          visible: indexNav == indexOfItem ? true : false,
        )
      ],
    );
  }
}
