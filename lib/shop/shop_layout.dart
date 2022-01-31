import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/functions.dart';
import 'package:shop_app/search/search_screen.dart';
import 'package:shop_app/shop/cubit/shop_cubit.dart';
import 'package:shop_app/shop/cubit/shop_states.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var shopCubit = ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(shopCubit.title[shopCubit.currentIndex]),
            actions: [
              IconButton(
                  onPressed: () {
                    navigateTo(context, const SearchScreen());
                  },
                  icon: const Icon(
                    Icons.search_sharp,
                    size: 33.0,
                  )),
            ],
          ),
          body: shopCubit.bottomScreen[shopCubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 25.0,
            items: shopCubit.bottomItems,
            currentIndex: shopCubit.currentIndex,
            onTap: (index) => shopCubit.changeBottom(index),
          ),
        );
      },
    );
  }
}
