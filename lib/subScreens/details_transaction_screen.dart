import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:money_assistant_final/customWidgets/custom_separator.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/customWidgets/sized_box_custom.dart';
import 'package:money_assistant_final/globalUsageValues.dart';
import 'package:money_assistant_final/main.dart';
import 'package:money_assistant_final/mainScreens/category/screen_category.dart';
import 'package:money_assistant_final/mainScreens/transaction/add_transaction_date_cubit/date_change_transaction_cubit.dart';
import 'package:money_assistant_final/mainScreens/transaction/date_change_cubit/change_date_cubit.dart';
import 'package:money_assistant_final/model/model_class.dart';
import 'package:money_assistant_final/subScreens/delete_confirmation_dialog.dart';
import 'package:money_assistant_final/subScreens/show_category_list_dialog.dart';

import '../mainScreens/transaction/transaction_bloc/transaction_bloc.dart';
import '../notification.dart';

class DetailsTransactionPage extends StatefulWidget {
  final Transaction detailTileKey;

  const DetailsTransactionPage({Key? key, required this.detailTileKey})
      : super(key: key);

  @override
  State<DetailsTransactionPage> createState() => _DetailsTransactionPageState();
}

class _DetailsTransactionPageState extends State<DetailsTransactionPage> {
  Color? tabColor = incomeBlue;
  bool? transactionType;
  TabController? tabController;
  String? categorySelect;
  late DateTime initialDate;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    transactionType = widget.detailTileKey.transactionType;
    initialDate = widget.detailTileKey.date;
    categorySelect = widget.detailTileKey.category;
    _amountController.text = widget.detailTileKey.amount.toString();
    _notesController.text = widget.detailTileKey.notes;
    _categoryController.text = widget.detailTileKey.category;
    _dateController.text = dateFormatterFull.format(widget.detailTileKey.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DateChangeTransactionCubit(),
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
          if (state is TransactionUpdateSuccess) {
            Navigator.pop(context);
            return;
          }
        },
        child: Scaffold(
          backgroundColor: commonWhite,
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: transactionType == true ? incomeBlue : expenseRed),
            backgroundColor: commonWhite,
            foregroundColor: secondaryPurple,
            elevation: 0.5,
            title: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: CustomText(
                textData: transactionType == true ? 'INCOME' : 'EXPENSE',
                textSize: 22,
                textWeight: FontWeight.w600,
                textColor: transactionType == true ? incomeBlue : expenseRed,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                const CustomSizedBox(
                  heightRatio: .03,
                ),
                const CustomSizedBox(
                  heightRatio: .02,
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
                                child:
                                    CustomText(textData: 'Date', textSize: 17),
                                width: deviceWidth * .25,
                              ),
                              SizedBox(
                                width: deviceWidth * .59,
                                child: MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1),
                                  child: BlocBuilder<DateChangeTransactionCubit,
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
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            textScaleFactor: 1),
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
                                          fontFamily: 'Poppins', fontSize: 17),
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
                                  child: BlocBuilder<DateChangeTransactionCubit,
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
                                          controllerIndex = widget.detailTileKey
                                                      .transactionType ==
                                                  true
                                              ? 0
                                              : 1;
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
                                    },
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
                                        borderSide:
                                            BorderSide(color: secondaryPurple),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: secondaryPurple),
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
                                child:
                                    CustomText(textData: 'Notes', textSize: 17),
                                width: deviceWidth * .25,
                              ),
                              SizedBox(
                                width: deviceWidth * .59,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: commonWhite),
                                  child: MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1),
                                    child: TextField(
                                      controller: _notesController,
                                      style: const TextStyle(
                                          fontFamily: 'Poppins', fontSize: 16),
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
                                  if (_amountController.text.isEmpty) {
                                    context
                                        .read<TransactionBloc>()
                                        .add(TransactionFieldEmpty());
                                  } else {
                                    final Transaction transaction = Transaction(
                                        widget.detailTileKey.transactionType,
                                        initialDate,
                                        categorySelect!,
                                        double.parse(_amountController.text),
                                        _notesController.text);
                                    context.read<TransactionBloc>().add(
                                        TransactionUpdate(
                                            transaction: transaction,
                                            key: widget.detailTileKey.key));
                                  }
                                  // Navigator.pop(context);
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
                                        borderRadius: BorderRadius.circular(7),
                                        side: BorderSide(color: commonBlack),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all(commonWhite),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<TransactionBloc>(),
                                        child: DeleteCategoryPage(
                                          keyTransaction:
                                              widget.detailTileKey.key,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: deviceHeight * .015),
                                    child: CustomText(
                                      textData: 'DELETE',
                                      textSize: 18,
                                      textColor: commonBlack,
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
    );
  }
}
