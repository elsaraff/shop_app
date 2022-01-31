import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:shop_app/core/dio_helper.dart';
import 'package:shop_app/login/cubit/login_states.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/network/end_points.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginIntialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    isPassword = !isPassword;
    emit(ShopChangePasswordVisibilityState());
  }

  ShopLoginModel loginModel;

  void userLogin({
    @required String email,
    @required String password,
  }) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);

      //debugPrint('welcome ' + loginModel.data.name.toString());

      //debugPrint('your Token is ' + loginModel.data.token.toString());

      emit(ShopLoginSuccessState(loginModel));
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
    });
  }
}
