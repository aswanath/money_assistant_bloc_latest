import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/customWidgets/sized_box_custom.dart';
import 'package:money_assistant_final/mainScreens/category/tab_controller_cubit_logic/tab_controller_cubit.dart';


import '../../globalUsageValues.dart';
import '../../model/model_class.dart';
import '../../subScreens/add_category_screen.dart';
import '../../subScreens/delete_confirmation_dialog.dart';
import '../../subScreens/edit_category_screen.dart';
import 'category_bloc_logic/category_bloc.dart';


class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  late Color tabColor;
  TabController? tabController;

  @override
  void initState() {
    controllerIndex = 0;
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabControllerCubit(),
      child: Scaffold(
        floatingActionButton: Padding(
          padding:  EdgeInsets.only(bottom: deviceHeight*.1),
          child: FloatingActionButton(
            foregroundColor: commonWhite,
            backgroundColor: secondaryPurple,
            onPressed: () {
              showDialog(
                  context: context, builder: (context) => AddCategoryPage());
            },
            child: const Icon(
              Icons.add,
              size: 32,
            ),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
          ),
        ),
        backgroundColor: commonWhite,
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
                      if (tabController!.index == 1) {
                        context
                            .read<CategoryBloc>()
                            .add(CategoryExpenseEvent());
                      } else {
                        context.read<CategoryBloc>().add(CategoryIncomeEvent());
                      }
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
                BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      List<Category> categoryList = [];
                      if (state is CategoryIncomeState) {
                        categoryList = state.categoryList;
                      } else if (state is CategoryExpenseState) {
                        categoryList = state.categoryList;
                      }
                      return Expanded(
                        child: categoryList.isEmpty
                            ? Center(
                          child: CustomText(
                            textData: 'No Categories Added',
                            textSize: 18,
                          ),
                        )
                            : ListView.separated(
                          itemCount: categoryList.length,
                          itemBuilder: (context, index) {
                            return CustomSizedBox(
                              widthRatio: 1,
                              heightRatio: .06,
                              widgetChild: DecoratedBox(
                                decoration:
                                 BoxDecoration(color: commonWhite),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        child: CustomText(
                                          textData: categoryList[index]
                                              .categoryName,
                                          textSize: 18,
                                          maxLines: 1,
                                          textOverflow: TextOverflow.clip,
                                        ),
                                        width: deviceWidth * .62,
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            visualDensity:
                                            VisualDensity.compact,
                                            splashRadius: .01,
                                            onPressed: () {
                                              int key =
                                                  categoryList[index].key;
                                              bool type = categoryList[index]
                                                  .transactionType;
                                              showDialog(
                                                  context: (context),
                                                  builder: (context) =>
                                                      EditCategoryPage(
                                                        indexKey: key,
                                                        transactionType: type,
                                                      ));
                                            },
                                            icon:  Icon(
                                              Icons.edit_outlined,
                                              color: secondaryPurple,
                                            ),
                                          ),
                                          IconButton(
                                            visualDensity:
                                            VisualDensity.compact,
                                            splashRadius: .01,
                                            onPressed: () {
                                              int key =
                                                  categoryList[index].key;
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    DeleteCategoryPage(
                                                      keyCategory: key,
                                                    ),
                                              );
                                            },
                                            icon:  Icon(
                                              Icons.delete_outline_outlined,
                                              color: expenseRed,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return  CustomSizedBox(
                              widthRatio: 1,
                              heightRatio: .0005,
                              widgetChild: DecoratedBox(
                                decoration: BoxDecoration(color: commonBlack),
                              ),
                            );
                          },
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
