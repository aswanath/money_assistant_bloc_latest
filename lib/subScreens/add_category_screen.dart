import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/customWidgets/sized_box_custom.dart';

import '../../model/model_class.dart';
import '../globalUsageValues.dart';
import '../mainScreens/category/category_bloc_logic/category_bloc.dart';

class AddCategoryPage extends StatelessWidget {
  final TextEditingController _categoryText = TextEditingController();

  AddCategoryPage({Key? key}) : super(key: key);

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
                          CustomText(textData: 'Add Category', textSize: 18),
                          TextField(
                            controller: _categoryText,
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
                          const CustomSizedBox(
                            heightRatio: .01,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7))),
                              backgroundColor: MaterialStateProperty.all(secondaryPurple),
                            ),
                            onPressed: () {
                              if (RegExp(r'^.*[a-zA-Z0-9]+.*$')
                                  .hasMatch(_categoryText.text)) {
                                context.read<CategoryBloc>().add(
                                    CategoryAddEvent(category: Category(controllerIndex ==
                                        0 ? true : false,
                                        _categoryText.text)));
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
