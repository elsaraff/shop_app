import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/functions.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/shop/cubit/shop_cubit.dart';
import 'package:shop_app/shop/cubit/shop_states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var shopCubit = ShopCubit.get(context);
        return ListView.separated(
          itemBuilder: (context, index) =>
              buildCatItem(shopCubit.categoriesModel.data.data[index]),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: shopCubit.categoriesModel.data.data.length,
        );
      },
    );
  }
}

Widget buildCatItem(DataModel model) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        children: [
          Container(
            color: Colors.white,
            child: Image(
              image: NetworkImage(model.image),
              width: 80,
              height: 80,
              // fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20.0),
          Text(
            model.name,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_sharp)
        ],
      ),
    );
