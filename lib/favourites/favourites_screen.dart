import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/functions.dart';
import 'package:shop_app/shop/cubit/shop_cubit.dart';
import 'package:shop_app/shop/cubit/shop_states.dart';
import 'package:shop_app/theme/cubit/theme_cubit.dart';
import 'package:shop_app/widgets/build_item.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        bool isLightMode = ThemeCubit.get(context).isLightMode;
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavoritesState,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) => buildListProduct(
                  ShopCubit.get(context)
                      .favoritesModel
                      .data
                      .data[index]
                      .product,
                  isLightMode,
                  context),
              separatorBuilder: (context, index) => myDivider(),
              itemCount:
                  ShopCubit.get(context).favoritesModel.data.data.length),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
