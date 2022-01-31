import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/functions.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shop/cubit/shop_cubit.dart';
import 'package:shop_app/shop/cubit/shop_states.dart';
import 'package:shop_app/theme/cubit/theme_cubit.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var shopCubit = ShopCubit.get(context);
        bool isLightMode = ThemeCubit.get(context).isLightMode;

        return ConditionalBuilder(
          condition:
              shopCubit.homeModel != null && shopCubit.categoriesModel != null,
          builder: (context) => buildProductBody(context, shopCubit.homeModel,
              shopCubit.categoriesModel, isLightMode),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

/*______________________________________________________________________*/
  Widget buildProductBody(context, HomeModel homeModel,
          CategoriesModel categoriesModel, bool isLightMode) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBannersCarousel(homeModel),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myDivider(),
                  //____________________________________________________________
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            buildCategoryItem(categoriesModel.data.data[index]),
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 5,
                            ),
                        itemCount: categoriesModel.data.data.length),
                  ),
                  myDivider(),
                  //____________________________________________________________
                  const Text(
                    'New Products',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Container(
              color: isLightMode ? Colors.grey : Colors.black54,
              child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 1 / 1.65,
                  children: List.generate(
                      homeModel.data.products.length,
                      (index) => buildGridProduct(context,
                          homeModel.data.products[index], isLightMode))),
            )
          ],
        ),
      );

  /*______________________________________________________________________*/

  Widget buildBannersCarousel(HomeModel model) => CarouselSlider(
      items: model.data.banners
          .map((e) => Image(
                image: NetworkImage(e.image),
                width: double.infinity,
                fit: BoxFit.cover,
              ))
          .toList(),
      options: CarouselOptions(
        height: 250.0,
        viewportFraction: 1.0, //0 to 1
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(seconds: 1),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
      ));

/*______________________________________________________________________*/

  Widget buildCategoryItem(DataModel model) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            color: Colors.white,
            child: Image(
              image: NetworkImage(model.image),
              fit: BoxFit.cover,
              width: 100.0,
              height: 100.0,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
            width: 100.0,
            child: Text(model.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: Colors.white)),
          )
        ],
      );

/*______________________________________________________________________*/

  Widget buildGridProduct(context, ProductModel model, bool isLightMode) =>
      Container(
        color: isLightMode ? Colors.white : Colors.black87,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Container(
                color: Colors.white,
                child: Image(
                  image: NetworkImage(model.image),
                  width: double.infinity,
                  height: 200.0,
                ),
              ),
              if (model.discount != 0)
                Container(
                  color: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Discount',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: isLightMode ? Colors.black : Colors.white,
                      fontSize: 14.0,
                      height: 1.3),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      '${model.price} L.E',
                      style: const TextStyle(
                          fontSize: 13.0, color: Colors.redAccent),
                    ),
                    const SizedBox(width: 5.0),
                    if (model.discount != 0)
                      Text(
                        '${model.oldPrice} L.E',
                        style: TextStyle(
                            fontSize: 11.0,
                            color: isLightMode ? Colors.grey : Colors.white70,
                            decoration: TextDecoration.lineThrough),
                      ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          ShopCubit.get(context).favorites[model.id]
                              ? Colors.red
                              : Colors.grey,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            ShopCubit.get(context).changeFavorites(model.id);
                          },
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 16.0,
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
}
