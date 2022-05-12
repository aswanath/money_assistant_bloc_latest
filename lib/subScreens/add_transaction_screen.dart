import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_assistant_final/globalUsageValues.dart';
import 'package:money_assistant_final/mainScreens/category/tab_controller_cubit_logic/tab_controller_cubit.dart';
import 'package:money_assistant_final/mainScreens/transaction/add_transaction_date_cubit/date_change_transaction_cubit.dart';
import 'package:money_assistant_final/subScreens/show_category_list_dialog.dart';
import '../customWidgets/custom_text.dart';
import '../customWidgets/sized_box_custom.dart';
import '../mainScreens/transaction/transaction_bloc/transaction_bloc.dart';
import '../model/model_class.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  Color? tabColor = incomeBlue;
  TabController? tabController;
  late DateTime initialDate;
  String? categorySelect = "";
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    controllerIndex = 0;
    initialDate = DateTime.now();
    _dateController.text = dateFormatterFull.format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TabControllerCubit()),
        BlocProvider(create: (context) => DateChangeTransactionCubit()),
      ],
      child: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionFieldEmptyState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomText(
                textData: 'Please enter transaction details',
                textSize: 16,
                textColor: commonWhite,
              ),
              backgroundColor: secondaryPurple,
            ));
            return;
          }
          if (state is TransactionAddedSuccess) {
            Navigator.pop(context);
            return;
          }
          if (state is TransactionContinueSuccess) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                          value: context.read<TransactionBloc>(),
                          child: const AddTransactionPage(),
                        )));
            return;
          }
        },
        child: Scaffold(
          backgroundColor: commonWhite,
          appBar: AppBar(
            backgroundColor: commonWhite,
            foregroundColor: secondaryPurple,
            elevation: 0,
            title: CustomText(
              textData: 'ADD',
              textSize: 18,
              textColor: secondaryPurple,
              textWeight: FontWeight.w600,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      tabController = DefaultTabController.of(context)!;
                      tabController!.addListener(() {
                        context
                            .read<TabControllerCubit>()
                            .changeColor(tabController!.index);
                        controllerIndex = tabController!.index;
                        _categoryController.text = '';
                      });
                      return Column(
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
                        ],
                      );
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: deviceWidth * .08),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  child: CustomText(
                                      textData: 'Date', textSize: 17),
                                  width: deviceWidth * .25,
                                ),
                                SizedBox(
                                  width: deviceWidth * .59,
                                  child: MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1),
                                    child: BlocBuilder<
                                            DateChangeTransactionCubit,
                                            DateChangeTransactionState>(
                                        builder: (context, state) {
                                      if (state is DateChangeTransaction) {
                                        _dateController.text = dateFormatterFull
                                            .format(state.dateTime);
                                        initialDate = state.dateTime;
                                      }
                                      return TextField(
                                        readOnly: true,
                                        enableInteractiveSelection: false,
                                        onTap: () {
                                          showDatePicker(
                                                  builder: (context, child) {
                                                    return MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              textScaleFactor:
                                                                  1),
                                                      child: Theme(
                                                          data: ThemeData(
                                                              colorScheme:
                                                                  ColorScheme.light(
                                                                      primary:
                                                                          secondaryPurple)),
                                                          child: child!),
                                                    );
                                                  },
                                                  context: context,
                                                  initialDate: initialDate,
                                                  firstDate: DateTime(
                                                      DateTime.now().year - 10),
                                                  lastDate: DateTime.now())
                                              .then((value) {
                                            if (value != null) {
                                              context
                                                  .read<
                                                      DateChangeTransactionCubit>()
                                                  .changeDate(value);
                                            }
                                          });
                                        },
                                        controller: _dateController,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 17),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: deviceHeight * .005,
                                              bottom: deviceHeight * .005),
                                          isDense: true,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryPurple),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryPurple),
                                          ),
                                        ),
                                        cursorColor: secondaryPurple,
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            const CustomSizedBox(
                              heightRatio: .015,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  child: CustomText(
                                      textData: 'Category', textSize: 17),
                                  width: deviceWidth * .25,
                                ),
                                SizedBox(
                                  width: deviceWidth * .59,
                                  child: MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1),
                                    child: BlocBuilder<
                                            DateChangeTransactionCubit,
                                            DateChangeTransactionState>(
                                        builder: (context, state) {
                                      if (state is CategorySelectState) {
                                        categorySelect = state.category;
                                        _categoryController.text =
                                            state.category;
                                      }
                                      return TextField(
                                        readOnly: true,
                                        enableInteractiveSelection: false,
                                        onTap: () async {
                                          var result = await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const ShowCategoryPage());
                                          if (result != null) {
                                            context
                                                .read<
                                                    DateChangeTransactionCubit>()
                                                .categorySelect(result);
                                          }
                                        },
                                        controller: _categoryController,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 17),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: deviceHeight * .005,
                                              bottom: deviceHeight * .005),
                                          isDense: true,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryPurple),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryPurple),
                                          ),
                                        ),
                                        cursorColor: secondaryPurple,
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            const CustomSizedBox(
                              heightRatio: .015,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  child: CustomText(
                                      textData: 'Amount', textSize: 17),
                                  width: deviceWidth * .25,
                                ),
                                SizedBox(
                                  width: deviceWidth * .59,
                                  child: MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1),
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                          RegExp(r"[\s,-]"),
                                        ),
                                        FilteringTextInputFormatter.allow(RegExp(
                                            r"^(?:0|[1-9]\d+|)?(?:.?\d*)?$"))
                                      ],
                                      controller: _amountController,
                                      enableInteractiveSelection: false,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            top: deviceHeight * .005,
                                            bottom: deviceHeight * .005),
                                        isDense: true,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: secondaryPurple),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: secondaryPurple),
                                        ),
                                      ),
                                      cursorColor: secondaryPurple,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const CustomSizedBox(
                              heightRatio: .015,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  child: CustomText(
                                      textData: 'Notes', textSize: 17),
                                  width: deviceWidth * .25,
                                ),
                                SizedBox(
                                  width: deviceWidth * .59,
                                  child: DecoratedBox(
                                    decoration:
                                        BoxDecoration(color: commonWhite),
                                    child: MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1),
                                      child: TextField(
                                        controller: _notesController,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: deviceHeight * .005,
                                              bottom: deviceHeight * .005),
                                          isDense: true,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryPurple),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryPurple),
                                          ),
                                        ),
                                        cursorColor: secondaryPurple,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const CustomSizedBox(
                              heightRatio: .05,
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7))),
                                    backgroundColor: MaterialStateProperty.all(
                                        secondaryPurple),
                                  ),
                                  onPressed: () {
                                    if (categorySelect == "" ||
                                        _amountController.text.isEmpty) {
                                      context
                                          .read<TransactionBloc>()
                                          .add(TransactionFieldEmpty());
                                    } else {
                                      final Transaction transaction =
                                          Transaction(
                                              tabController!.index == 0
                                                  ? true
                                                  : false,
                                              initialDate,
                                              categorySelect!,
                                              double.parse(
                                                  _amountController.text),
                                              _notesController.text);
                                      context.read<TransactionBloc>().add(
                                          TransactionAdded(
                                              transaction: transaction));
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: deviceWidth * .15,
                                        vertical: deviceHeight * .015),
                                    child: CustomText(
                                      textData: 'SAVE',
                                      textSize: 18,
                                      textColor: commonWhite,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          side: BorderSide(color: commonBlack),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              commonWhite),
                                    ),
                                    onPressed: () {
                                      if (categorySelect == "" ||
                                          _amountController.text.isEmpty) {
                                        context
                                            .read<TransactionBloc>()
                                            .add(TransactionFieldEmpty());
                                      } else {
                                        final Transaction transaction =
                                            Transaction(
                                                tabController!.index == 0
                                                    ? true
                                                    : false,
                                                initialDate,
                                                categorySelect!,
                                                double.parse(
                                                    _amountController.text),
                                                _notesController.text);
                                        context.read<TransactionBloc>().add(
                                            TransactionContinue(
                                                transaction: transaction));
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: deviceHeight * .015),
                                      child: FittedBox(
                                        child: CustomText(
                                          textData: 'CONTINUE',
                                          textSize: 18,
                                          textColor: commonBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
