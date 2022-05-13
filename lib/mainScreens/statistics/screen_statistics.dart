import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/globalUsageValues.dart';
import 'package:money_assistant_final/main.dart';
import 'package:money_assistant_final/mainScreens/category/tab_controller_cubit_logic/tab_controller_cubit.dart';
import 'package:money_assistant_final/mainScreens/statistics/chart_cubit.dart';
import 'package:money_assistant_final/mainScreens/transaction/date_change_cubit/change_date_cubit.dart';
import 'package:money_assistant_final/mainScreens/transaction/popup_menu_cubit/popup_menu_cubit.dart';
import 'package:money_assistant_final/mainScreens/transaction/screen_transactions.dart';
import 'package:money_assistant_final/services/chart_repository.dart';
import 'package:money_assistant_final/services/transactions_repository.dart';
import '../../customWidgets/sized_box_custom.dart';
import '../../iconFont/my_flutter_app_icons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../model/model_class.dart';
import '../category/category_bloc_logic/category_bloc.dart';
import '../transaction/transaction_bloc/transaction_bloc.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with TickerProviderStateMixin {
  Color? tabColor = incomeBlue;
  TabController? tabController;
  late DateTime finalDate;
  late DateTime initialDate;
  late DateTime monthYear;
  String popupItem = 'Monthly';
  late List<Transaction> firstFilterList;
  final PopupMenuCubit popupMenuCubit = PopupMenuCubit();
  late ChangeDateCubit changeDateCubit;
  late TransactionBloc transactionBloc;

  @override
  void initState() {
    initialDate = finalDate = monthYear = DateTime.now();
    tabController = TabController(length: 2, vsync: this);
    changeDateCubit = ChangeDateCubit(popupMenuCubit: popupMenuCubit);
    transactionBloc = TransactionBloc(
        transactionRepository: context.read<TransactionRepository>(),
        changeDateCubit: changeDateCubit, categoryBloc: context.read<CategoryBloc>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TabControllerCubit()),
          BlocProvider(create: (context) => popupMenuCubit),
          BlocProvider(create: (context) => changeDateCubit),
          BlocProvider(
              create: (context) => transactionBloc),
          BlocProvider(create: (context)=> ChartCubit(transactionBloc: transactionBloc, chartDatabase: context.read<ChartRepository>(), transactionRepository: context.read<TransactionRepository>()))
        ],
        child: Scaffold(
          backgroundColor: commonWhite,
          body: SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: deviceHeight * .01),
                    child: CustomSizedBox(
                      heightRatio: 0.06,
                      widthRatio: 1,
                      widgetChild: DecoratedBox(
                        decoration: BoxDecoration(
                          color: commonWhite,
                        ),
                        child: BlocBuilder<PopupMenuCubit, PopupMenuState>(
                          builder: (context, state) {
                            state as PopupMenuChange;
                            popupItem = state.item;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (state.item == 'Period') ...[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showDatePicker(
                                              builder: (context, child) {
                                                return Theme(
                                                    data: ThemeData(
                                                        colorScheme:
                                                            ColorScheme.light(
                                                                primary:
                                                                    secondaryPurple)),
                                                    child: child!);
                                              },
                                              context: context,
                                              initialDate: initialDate,
                                              firstDate: DateTime(
                                                  DateTime.now().year - 10),
                                              lastDate: DateTime.now(),
                                            ).then(
                                              (value) {
                                                if (value != null) {
                                                  context
                                                      .read<ChangeDateCubit>()
                                                      .changeDatePeriod(value,
                                                          finalDate, true);
                                                }
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: secondaryPurple,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Row(
                                              children: [
                                                BlocBuilder<ChangeDateCubit,
                                                    ChangeDateState>(
                                                  builder: (context, state) {
                                                    state as ChangeDatePeriod;
                                                    initialDate =
                                                        state.firstDate;
                                                    finalDate = state.finalDate;
                                                    return CustomText(
                                                        textData:
                                                            '${dateFormatterFull.format(state.firstDate)} ',
                                                        textSize: 15);
                                                  },
                                                ),
                                                Icon(
                                                  Icons.calendar_today,
                                                  size: 14,
                                                  color: secondaryPurple,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        CustomText(
                                            textData: ' ~ ', textSize: 16),
                                        GestureDetector(
                                          onTap: () {
                                            showDatePicker(
                                                    builder: (context, child) {
                                                      return Theme(
                                                          data: ThemeData(
                                                            colorScheme:
                                                                ColorScheme.light(
                                                                    primary:
                                                                        secondaryPurple),
                                                          ),
                                                          child: child!);
                                                    },
                                                    context: context,
                                                    initialDate: finalDate,
                                                    firstDate: DateTime(
                                                        DateTime.now().year -
                                                            10),
                                                    lastDate: DateTime.now())
                                                .then((value) {
                                              if (value != null) {
                                                context
                                                    .read<ChangeDateCubit>()
                                                    .changeDatePeriod(
                                                        initialDate,
                                                        value,
                                                        false);
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: secondaryPurple,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Row(
                                              children: [
                                                BlocBuilder<ChangeDateCubit,
                                                    ChangeDateState>(
                                                  builder: (context, state) {
                                                    state as ChangeDatePeriod;
                                                    return CustomText(
                                                        textData:
                                                            '${dateFormatterFull.format(state.finalDate)} ',
                                                        textSize: 15);
                                                  },
                                                ),
                                                Icon(
                                                  Icons.calendar_today,
                                                  size: 14,
                                                  color: secondaryPurple,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else if (state.item == 'Yearly') ...[
                                  Row(
                                    children: [
                                      const CustomSizedBox(
                                        widthRatio: .01,
                                      ),
                                      IconButton(
                                        splashRadius: 0.01,
                                        onPressed: () {
                                          context
                                              .read<ChangeDateCubit>()
                                              .decrementYear(monthYear);
                                        },
                                        icon: Icon(
                                          MyFlutterApp.left_open_outline,
                                          color: secondaryPurple,
                                          size: 20,
                                        ),
                                        visualDensity:
                                            const VisualDensity(horizontal: -4),
                                      ),
                                      BlocBuilder<ChangeDateCubit,
                                          ChangeDateState>(
                                        builder: (context, state) {
                                          state as ChangeDateYear;
                                          monthYear = state.dateTime;
                                          return CustomText(
                                              textData:
                                                  monthYear.year.toString(),
                                              textColor: commonBlack,
                                              textSize: 16);
                                        },
                                      ),
                                      IconButton(
                                          splashRadius: .01,
                                          onPressed: () {
                                            context
                                                .read<ChangeDateCubit>()
                                                .incrementYear(monthYear);
                                          },
                                          icon: Icon(
                                            MyFlutterApp.right_open_outline,
                                            color: secondaryPurple,
                                            size: 20,
                                          ),
                                          visualDensity: const VisualDensity(
                                              horizontal: -4)),
                                    ],
                                  ),
                                ] else ...[
                                  Row(
                                    children: [
                                      const CustomSizedBox(
                                        widthRatio: .01,
                                      ),
                                      IconButton(
                                        splashRadius: 0.01,
                                        onPressed: () {
                                          context
                                              .read<ChangeDateCubit>()
                                              .decrementMonth(monthYear);
                                        },
                                        icon: Icon(
                                          MyFlutterApp.left_open_outline,
                                          color: secondaryPurple,
                                          size: 20,
                                        ),
                                        visualDensity:
                                            const VisualDensity(horizontal: -4),
                                      ),
                                      BlocBuilder<ChangeDateCubit,
                                          ChangeDateState>(
                                        builder: (context, state) {
                                          state as ChangeDateMonth;
                                          monthYear = state.dateTime;
                                          return CustomText(
                                              textData: dateFormatterMonth
                                                  .format(monthYear),
                                              textColor: commonBlack,
                                              textSize: 16);
                                        },
                                      ),
                                      IconButton(
                                          splashRadius: .01,
                                          onPressed: () {
                                            context
                                                .read<ChangeDateCubit>()
                                                .incrementMonth(monthYear);
                                          },
                                          icon: Icon(
                                            MyFlutterApp.right_open_outline,
                                            color: secondaryPurple,
                                            size: 20,
                                          ),
                                          visualDensity: const VisualDensity(
                                              horizontal: -4)),
                                    ],
                                  ),
                                ],
                                PopupMenuButton(
                                  onSelected: (val) {
                                    if (val != null) {
                                      context
                                          .read<PopupMenuCubit>()
                                          .changePopupMenu(val.toString());
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: deviceWidth * .03),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: secondaryPurple),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          CustomText(
                                              textData: state.item,
                                              textSize: 14),
                                          const Icon(Icons
                                              .keyboard_arrow_down_outlined)
                                        ],
                                      ),
                                    ),
                                  ),
                                  initialValue: state.item,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: CustomText(
                                          textData: 'Monthly', textSize: 14),
                                      value: 'Monthly',
                                    ),
                                    PopupMenuItem(
                                      child: CustomText(
                                          textData: 'Yearly', textSize: 14),
                                      value: 'Yearly',
                                    ),
                                    PopupMenuItem(
                                      child: CustomText(
                                          textData: 'Period', textSize: 14),
                                      value: 'Period',
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      tabController = DefaultTabController.of(context)!;
                      tabController!.addListener(() {
                        context
                            .read<TabControllerCubit>()
                            .changeColor(tabController!.index);
                        context.read<TransactionBloc>().add(
                            TransactionFilterEvent(
                                popupItem: popupItem,
                                firstDate: popupItem == 'Period'
                                    ? initialDate
                                    : monthYear,
                                secondDate: finalDate));
                        controllerIndex = tabController!.index;
                        // if (tabController!.index == 1) {
                        //   tabColor = expenseRed;
                        // } else {
                        //   tabColor = incomeBlue;
                        // }
                      });
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BlocBuilder<TabControllerCubit, TabControllerState>(
                            builder: (context, state) {
                              tabColor = state.props[0] as Color;
                              return TabBar(
                                padding: const EdgeInsets.only(
                                    left: 40, right: 40, top: 40, bottom: 20),
                                indicator: BoxDecoration(
                                    color: state.props[0] as Color,
                                    borderRadius: BorderRadius.circular(7)),
                                labelColor: commonWhite,
                                unselectedLabelColor: commonBlack,
                                tabs: [
                                  Tab(
                                    child: CustomText(
                                      textData: 'INCOME',
                                      textSize: 18,
                                      textWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Tab(
                                    child: CustomText(
                                      textData: 'EXPENSE',
                                      textSize: 18,
                                      textWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            child:
                                BlocBuilder<TransactionBloc, TransactionState>(
                              builder: (context, state) {
                                double incomeAmount = 0;
                                double expenseAmount = 0;
                                if (state is TransactionFiltered) {
                                  incomeAmount = state.incomeAmount;
                                  expenseAmount = state.expenseAmount;
                                  firstFilterList = state.list;
                                }
                                return CustomText(
                                    textData: tabController!.index == 0
                                        ? 'Total Income: $incomeAmount'
                                        : 'Total Expense: $expenseAmount',
                                    textSize: 20);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  BlocBuilder<ChartCubit, ChartState>(
                    builder: (context, state) {
                      state as ChartStatisticsChangeState;
                      List<GDPData> incomeList = state.incomeTransaction;
                      List<GDPData> expenseList = state.expenseTransaction;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ((incomeList.isEmpty &&
                              tabController!.index == 0) ||
                              (expenseList
                                  .isEmpty &&
                                  tabController!.index == 1))
                              ? Center(
                            child: CustomText(
                                textData: 'No data to show', textSize: 18),
                          )
                              : SfCircularChart(
                            centerY: '160',
                            legend: Legend(
                                textStyle:
                                const TextStyle(fontFamily: 'POPPINS'),
                                overflowMode: LegendItemOverflowMode.scroll,
                                offset: Offset(-140, deviceHeight * .42),
                                isVisible: true,
                                isResponsive: true,
                                orientation: LegendItemOrientation.vertical,
                                height: '40%',
                                width: '100%'),
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              color: secondaryPurple,
                              textStyle:
                              const TextStyle(fontFamily: 'Poppins'),
                            ),
                            palette: paletteColor,
                            backgroundColor: commonWhite,
                            series: <CircularSeries>[
                              PieSeries<GDPData, String>(
                                strokeColor: commonWhite,
                                strokeWidth: 1,
                                explodeGesture: ActivationMode.singleTap,
                                explode: tabController?.index == 0
                                    ? (incomeList
                                    .length ==
                                    1
                                    ? false
                                    : true)
                                    : (expenseList
                                    .length ==
                                    1
                                    ? false
                                    : true),
                                radius: (deviceHeight * .16).toString(),
                                dataSource: tabController?.index == 0
                                    ? incomeList
                                    : expenseList,
                                xValueMapper: (GDPData data, _) =>
                                data.continent,
                                yValueMapper: (GDPData data, _) => data.gdp,
                                dataLabelMapper: (GDPData data, _) =>
                                data.text,
                                dataLabelSettings: DataLabelSettings(
                                  color: tabController?.index == 0
                                      ? incomeBlue
                                      : expenseRed,
                                  connectorLineSettings:
                                  const ConnectorLineSettings(
                                      type: ConnectorType.curve),
                                  labelPosition:
                                  ChartDataLabelPosition.outside,
                                  isVisible: true,
                                  textStyle: const TextStyle(
                                      fontFamily: 'Poppins', fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, this.text);

  final String continent;
  final int gdp;
  final String text;
}
