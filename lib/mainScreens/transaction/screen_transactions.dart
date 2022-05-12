import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/main.dart';
import 'package:money_assistant_final/mainScreens/transaction/date_change_cubit/change_date_cubit.dart';
import 'package:money_assistant_final/mainScreens/transaction/icon_cubit_logic/icon_cubit.dart';
import 'package:money_assistant_final/mainScreens/transaction/popup_menu_cubit/popup_menu_cubit.dart';
import 'package:money_assistant_final/mainScreens/transaction/transaction_bloc/transaction_bloc.dart';
import 'package:money_assistant_final/services/transactions_repository.dart';
import 'package:money_assistant_final/subScreens/details_transaction_screen.dart';
import '../../customWidgets/sized_box_custom.dart';
import '../../globalUsageValues.dart';
import '../../iconFont/my_flutter_app_icons.dart';
import '../../model/model_class.dart';
import '../../subScreens/add_transaction_screen.dart';

double? totalIncome;
double? totalExpense;

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late DateTime monthYear;

  String searchText = "";
  String? currentDate;
  String? lastDate;
  late DateTime finalDate;
  late DateTime initialDate;
  String popupItem = 'Monthly';
  var transBox = Hive.box<Transaction>(boxTrans);
  final PopupMenuCubit popupMenuCubit = PopupMenuCubit();
  late ChangeDateCubit changeDateCubit;

  @override
  void initState() {
    // print("initistatsdfasdfsadfhaksdjfhksadfhj");
    changeDateCubit = ChangeDateCubit(popupMenuCubit: popupMenuCubit);
    initialDate = DateTime.now();
    finalDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => popupMenuCubit),
          BlocProvider(create: (context) => changeDateCubit),
          BlocProvider(
              create: (context) => TransactionBloc(
                  transactionRepository: context.read<TransactionRepository>(),
                  changeDateCubit: changeDateCubit)),
        ],
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: commonWhite,
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: deviceHeight * .1),
              child: FloatingActionButton(
                foregroundColor: commonWhite,
                backgroundColor: secondaryPurple,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddTransactionPage()));
                },
                child: const Icon(
                  Icons.add,
                  size: 32,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19)),
              ),
            ),
            appBar: PreferredSize(
              preferredSize: Size(deviceWidth, deviceHeight * .06),
              child: const CustomAppBar(),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  CustomSizedBox(
                    heightRatio: 0.06,
                    widthRatio: 1,
                    widgetChild: DecoratedBox(
                      decoration: BoxDecoration(
                        color: commonWhite,
                        border: Border(
                          bottom: BorderSide(color: secondaryPurple, width: .4),
                        ),
                      ),
                      child: BlocBuilder<PopupMenuCubit, PopupMenuState>(
                        builder: (context, state) {
                          state as PopupMenuChange;
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
                                                    .changeDatePeriod(
                                                        value, finalDate, true);
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
                                                  initialDate = state.firstDate;
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
                                      CustomText(textData: ' ~ ', textSize: 16),
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
                                                      DateTime.now().year - 10),
                                                  lastDate: DateTime.now())
                                              .then((value) {
                                            if (value != null) {
                                              context
                                                  .read<ChangeDateCubit>()
                                                  .changeDatePeriod(initialDate,
                                                      value, false);
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
                                            textData: monthYear.year.toString(),
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
                                  padding:
                                      EdgeInsets.only(right: deviceWidth * .03),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: secondaryPurple),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      children: [
                                        CustomText(
                                            textData: state.item, textSize: 14),
                                        const Icon(
                                            Icons.keyboard_arrow_down_outlined)
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomSizedBox(
                          heightRatio: .085,
                          widthRatio: .28,
                          widgetChild: Column(
                            children: [
                              CustomText(
                                textData: 'INCOME',
                                textSize: 18,
                                textColor: commonBlack,
                              ),
                              FittedBox(
                                child: BlocBuilder<TransactionBloc,
                                    TransactionState>(
                                  builder: (context, state) {
                                    double amount = 0;
                                    if (state is TransactionFilteredEmpty) {
                                      amount = 0;
                                    } else if (state is TransactionFiltered) {
                                      amount = state.incomeAmount;
                                    }
                                    return CustomText(
                                      textData:
                                          '₹ ${amount.toStringAsFixed(2)}',
                                      textSize: 18,
                                      textColor: incomeBlue,
                                      textWeight: FontWeight.w600,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomSizedBox(
                          heightRatio: .085,
                          widthRatio: .28,
                          widgetChild: Column(
                            children: [
                              CustomText(
                                textData: 'EXPENSE',
                                textSize: 18,
                                textColor: commonBlack,
                              ),
                              FittedBox(
                                child: BlocBuilder<TransactionBloc,
                                    TransactionState>(
                                  builder: (context, state) {
                                    double amount = 0;
                                    if (state is TransactionFilteredEmpty) {
                                      amount = 0;
                                    } else if (state is TransactionFiltered) {
                                      amount = state.expenseAmount;
                                    }
                                    return CustomText(
                                      textData:
                                          '₹ ${amount.toStringAsFixed(2)}',
                                      textSize: 18,
                                      textColor: expenseRed,
                                      textWeight: FontWeight.w600,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomSizedBox(
                          heightRatio: .085,
                          widthRatio: .28,
                          widgetChild: Column(
                            children: [
                              CustomText(
                                textData: 'TOTAL',
                                textSize: 18,
                                textColor: commonBlack,
                              ),
                              FittedBox(
                                child: BlocBuilder<TransactionBloc,
                                    TransactionState>(
                                  builder: (context, state) {
                                    double amount = 0;
                                    if (state is TransactionFilteredEmpty) {
                                      amount = 0;
                                    } else if (state is TransactionFiltered) {
                                      amount = (state.incomeAmount -
                                          state.expenseAmount);
                                    }
                                    return CustomText(
                                      textData:
                                          '₹ ${amount.toStringAsFixed(2)}',
                                      textSize: 18,
                                      textColor: commonBlack,
                                      textWeight: FontWeight.w600,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomSizedBox(
                    heightRatio: .01,
                    widthRatio: 1,
                    widgetChild: DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: secondaryPurple, width: .4),
                      )),
                    ),
                  ),
                  BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, state) {
                    // List<Transaction> filterList = popupItem == 'Period'
                    //     ? periodFilterList(transBox)
                    //     : (popupItem == 'Monthly'
                    //         ? filteredLists(newBox)[0]
                    //         : filteredLists(newBox)[1]);
                    // List<Transaction> newTransactionList =
                    //     filterList.where((element) {
                    //   if (element.category
                    //       .toLowerCase()
                    //       .contains(searchText.toLowerCase())) {
                    //     return element.category
                    //         .toLowerCase()
                    //         .contains(searchText.toLowerCase());
                    //   } else {
                    //     return element.notes
                    //         .toLowerCase()
                    //         .contains(searchText.toLowerCase());
                    //   }
                    // }).toList();
                    if (state is TransactionFilteredEmpty) {
                      return Expanded(
                          child: Center(
                              child: CustomText(
                                  textData: 'No Transactions', textSize: 18)));
                    } else {
                      state as TransactionFiltered;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: state.list.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailsTransactionPage(
                                    detailTileKey: state.list[index],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child: CustomSizedBox(
                                widthRatio: 1,
                                heightRatio: .065,
                                widgetChild: DecoratedBox(
                                  decoration: BoxDecoration(color: tileGrey),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            //Date of Transaction
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  width: deviceWidth * .09,
                                                  height: deviceHeight * .022,
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: dateFormatterDay
                                                                    .format(state
                                                                        .list[
                                                                            index]
                                                                        .date) ==
                                                                'Sun'
                                                            ? Colors.redAccent
                                                            : (dateFormatterDay.format(state
                                                                        .list[
                                                                            index]
                                                                        .date) ==
                                                                    'Sat'
                                                                ? Colors.blue
                                                                : dateGrey)),
                                                    child: CustomText(
                                                      textSize: 12,
                                                      textData: dateFormatterDay
                                                          .format(state
                                                              .list[index]
                                                              .date),
                                                      textAlignment:
                                                          TextAlign.center,
                                                      textColor: commonWhite,
                                                    ),
                                                  ),
                                                ),
                                                const CustomSizedBox(
                                                  heightRatio: .005,
                                                ),
                                                CustomSizedBox(
                                                  widthRatio: .12,
                                                  heightRatio: .022,
                                                  widgetChild: CustomText(
                                                    textAlignment:
                                                        TextAlign.center,
                                                    textData: dateFormatterDate
                                                        .format(state
                                                            .list[index].date),
                                                    textSize: 12,
                                                    textWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        //Transaction Category
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              child: CustomText(
                                                maxLines: 1,
                                                textData:
                                                    state.list[index].category,
                                                textOverflow: TextOverflow.clip,
                                                textSize: 16,
                                                textWeight: FontWeight.w600,
                                                textAlignment: TextAlign.start,
                                              ),
                                              width: deviceWidth * .51,
                                            ),
                                            state.list[index].notes.isNotEmpty
                                                ? CustomSizedBox(
                                                    widgetChild: CustomText(
                                                      maxLines: 1,
                                                      textData: state
                                                          .list[index].notes,
                                                      textOverflow:
                                                          TextOverflow.clip,
                                                      textSize: 12,
                                                      textAlignment:
                                                          TextAlign.start,
                                                    ),
                                                    widthRatio: .51,
                                                    heightRatio: .025,
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                        //Transaction Amount
                                        CustomSizedBox(
                                          widthRatio: .24,
                                          heightRatio: .065,
                                          widgetChild: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              FittedBox(
                                                child: CustomText(
                                                  textColor: state.list[index]
                                                              .transactionType ==
                                                          true
                                                      ? incomeBlue
                                                      : expenseRed,
                                                  textData:
                                                      '₹ ${state.list[index].amount.toStringAsFixed(2)}',
                                                  textSize: 16,
                                                  textWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          );
        }));
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IconCubit, IconState>(
      builder: (context, state) {
        if (state is IconChangeNormal) {
          return AppBar(
            backgroundColor: commonWhite,
            elevation: .5,
            centerTitle: false,
            title: CustomText(
              textData: 'Money Assistant',
              textSize: 22,
              textColor: secondaryPurple,
              textWeight: FontWeight.w600,
            ),
            actions: [
              IconButton(
                splashRadius: 0.01,
                onPressed: () {
                  context.read<IconCubit>().changeToSearch();
                },
                icon: Icon(
                  Icons.search_outlined,
                  color: secondaryPurple,
                ),
              ),
            ],
          );
        } else {
          return AppBar(
            backgroundColor: commonWhite,
            elevation: .5,
            centerTitle: false,
            title: Row(
              children: [
                CustomSizedBox(
                  widthRatio: .76,
                  heightRatio: .048,
                  widgetChild: DecoratedBox(
                    decoration: BoxDecoration(
                        color: searchTabGrey,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        const CustomSizedBox(
                          widthRatio: .01,
                        ),
                        Icon(
                          Icons.search_outlined,
                          color: secondaryPurple,
                          size: 30,
                        ),
                        const CustomSizedBox(
                          widthRatio: .01,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: TextField(
                            onChanged: (val) {
                              // setState(() {
                              //   searchText = val;
                              // });
                            },
                            style: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 16),
                            textInputAction: TextInputAction.search,
                            autofocus: true,
                            decoration: null,
                            cursorHeight: 22,
                            cursorColor: commonBlack,
                            textAlignVertical: TextAlignVertical.center,
                          ),
                          width: deviceWidth * .65,
                          height: deviceHeight * .048,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            actions: [
              IconButton(
                splashRadius: 0.01,
                onPressed: () {
                  context.read<IconCubit>().changeToNormal();
                },
                icon: Icon(
                  Icons.close,
                  color: secondaryPurple,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

double incomeSum(List<Transaction> list) {
  double incomeTotal = 0;
  for (int i = 0; i < list.length; i++) {
    if (list[i].transactionType == true) {
      incomeTotal += list[i].amount;
    }
  }
  totalIncome = incomeTotal;
  return incomeTotal;
}

double expenseSum(List<Transaction> list) {
  double expenseTotal = 0;
  for (int i = 0; i < list.length; i++) {
    if (list[i].transactionType == false) {
      expenseTotal += list[i].amount;
    }
  }
  totalExpense = expenseTotal;
  return expenseTotal;
}
