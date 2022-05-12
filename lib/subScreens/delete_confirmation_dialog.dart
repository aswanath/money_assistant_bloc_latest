import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';

import '../globalUsageValues.dart';
import '../mainScreens/category/category_bloc_logic/category_bloc.dart';
import '../mainScreens/transaction/transaction_bloc/transaction_bloc.dart';



class DeleteCategoryPage extends StatelessWidget {
  final int? keyCategory;
  final int? keyTransaction;

  DeleteCategoryPage({Key? key, this.keyCategory, this.keyTransaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryDeleteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 10,
              behavior: SnackBarBehavior.fixed,
              backgroundColor: secondaryPurple,
              content: CustomText(
                textData: 'Transactions with this Category exists',
                textSize: 16,
                textColor: commonWhite,
              ),
            ),
          );
        }
      },
      child: AlertDialog(
        content: CustomText(
          textData: 'Do you want to delete it?',
          textSize: 18,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: CustomText(
              textData: "NO",
              textSize: 18,
              textColor: secondaryPurple,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                if (keyCategory == null) {
                  // context.read<TransactionBloc>().add(
                  //     TransactionDeleteEvent(key: keyTransaction!));
                  Navigator.pop(context);
                } else {
                  context
                      .read<CategoryBloc>()
                      .add(CategoryDeleteEvent(key: keyCategory!));
                  Navigator.pop(context);
                }
              },
              child: CustomText(
                textData: 'YES',
                textSize: 18,
                textColor: secondaryPurple,
              ),
            ),
          )
        ],
      ),
    );
  }
}
