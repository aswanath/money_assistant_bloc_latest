import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'date_change_transaction_state.dart';

class DateChangeTransactionCubit extends Cubit<DateChangeTransactionState> {
  DateChangeTransactionCubit() : super(DateChangeInitial());

  void changeDate(DateTime dateTime) => emit(DateChangeTransaction(dateTime: dateTime));

  void categorySelect(String category) => emit(CategorySelectState(category: category));
}
