import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/customWidgets/sized_box_custom.dart';

import '../globalUsageValues.dart';
import '../mainScreens/category/category_bloc_logic/category_bloc.dart';
import '../services/category_repository.dart';


class EditCategoryPage extends StatefulWidget {
  final bool transactionType;
  final int indexKey;

  const EditCategoryPage(
      {Key? key, required this.indexKey, required this.transactionType})
      : super(key: key);

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final CategoryRepository _categoryDatabase = CategoryRepository();
  final TextEditingController _categoryName = TextEditingController();

  @override
  void initState() {
    _categoryName.text =
        _categoryDatabase
            .getCategory(widget.indexKey)
            .categoryName
            .toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: BlocListener<CategoryBloc, CategoryState>(
                listener: (context, state) {
                  if(state is CategoryUpdateFailure){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        elevation: 10,
                        behavior: SnackBarBehavior.fixed,
                        backgroundColor: secondaryPurple,
                        content: CustomText(
                          textData: 'Category name exists',
                          textSize: 16,
                          textColor: commonWhite,
                        )));
                  }else if(state is CategoryUpdateSuccess){
                    Navigator.pop(context);
                  }
                },
                child: AlertDialog(
                  content: CustomSizedBox(
                    widthRatio: .3,
                    heightRatio: .2,
                    widgetChild: DecoratedBox(
                      decoration:  BoxDecoration(color: commonWhite),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText(textData: 'Edit Category', textSize: 18),
                          TextField(
                            controller: _categoryName,
                            cursorColor: secondaryPurple,
                            style: const TextStyle(fontFamily: 'Poppins'),
                            decoration:  InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: secondaryPurple),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: secondaryPurple),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7))),
                              backgroundColor: MaterialStateProperty.all(secondaryPurple),
                            ),
                            onPressed: () {
                              if (RegExp(r'^.*[a-zA-Z0-9]+.*$')
                                  .hasMatch(_categoryName.text)) {
                                context.read<CategoryBloc>().add(CategoryUpdateEvent(
                                    transactionType: widget.transactionType,
                                    key: widget.indexKey,
                                    newCategoryName: _categoryName.text));
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: deviceWidth * .08, vertical: 9),
                              child: CustomText(
                                textColor: commonWhite,
                                textData: 'SAVE',
                                textSize: 16,
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
      ),
    );
  }
}
