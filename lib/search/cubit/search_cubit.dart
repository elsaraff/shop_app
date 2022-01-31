import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/core/dio_helper.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/search/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel model;

  void search(String text) {
    emit(SearchLoadingState());
    DioHelper.postData(url: SEARCH, data: {'text': text, 'token': token})
        .then((value) {
      model = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(SearchErrorState());
    });
  }
}
