import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:shop_app/categories/categories_screen.dart';
import 'package:shop_app/core/dio_helper.dart';
import 'package:shop_app/favourites/favourites_screen.dart';
import 'package:shop_app/functions.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/products/products_screen.dart';
import 'package:shop_app/settings/settings_screen.dart';
import 'package:shop_app/shop/cubit/shop_states.dart';
import 'package:shop_app/widgets/show_toast.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopIntialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  //_____________________________________________________
  int currentIndex = 0;

  void changeBottom(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  List<String> title = [
    'Catch UP',
    'Categories',
    'Favorites',
    'Settings',
  ];

  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Categories'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.favorite), label: 'Favorites'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.settings), label: 'Settings'),
  ];

  List<Widget> bottomScreen = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavouritesScreen(),
    const SettingsScreen(),
  ];

  //_____________________________________________________

  HomeModel homeModel;
  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: token,
      lang: 'en',
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      //printFullText(homeModel.data.products[0].name.toString());

      for (var element in homeModel.data.products) {
        favorites.addAll({element.id: element.inFavorites});
      }
      //debugPrint(favorites.toString());

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  //_____________________________________________________

  CategoriesModel categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      lang: 'en',
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  //_____________________________________________________
  ChangeFavoritesModel changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId];
    emit(ShopChangeFavoritesState()); //to change avatar color (Quickly)

    DioHelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      //debugPrint(value.data.toString());
      if (!changeFavoritesModel.status) {
        favorites[productId] = !favorites[
            productId]; // if problem exist after change avatar color (Quickly)
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState());
      showToast(
          text: changeFavoritesModel.message.toString(),
          state: ToastStates.SUCCESS);
    }).catchError((error) {
      favorites[productId] = !favorites[productId];
      debugPrint(error.toString());
      showToast(
          text: changeFavoritesModel.message.toString(),
          state: ToastStates.ERROR);
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      //printFullText(value.data.toString());
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel userModel;
  void getUserData() {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel.data.name.toString());
      emit(ShopSuccessUserDataState(userModel));
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    @required String name,
    @required String email,
    @required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel.data.name.toString());
      emit(ShopSuccessUpdateUserState(userModel));
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}
