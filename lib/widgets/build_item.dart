import 'package:flutter/material.dart';
import 'package:shop_app/shop/cubit/shop_cubit.dart';

Widget buildListProduct(model, bool isLightMode, context,
        {bool isFavorites = true}) =>
    Container(
      color: isLightMode ? Colors.white : Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 120,
          width: double.infinity,
          child: Row(children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  color: Colors.white,
                  child: Image(
                    image: NetworkImage(model.image),
                    width: 120.0,
                    height: 120.0,
                  ),
                ),
                if (model.discount != 0 && isFavorites)
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
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: isLightMode ? Colors.black : Colors.white,
                        fontSize: 20.0),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Text(
                          model.price.toString(),
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.redAccent),
                        ),
                        const SizedBox(width: 5.0),
                        if (model.discount != 0 && isFavorites)
                          Text(
                            model.oldPrice.toString(),
                            style: TextStyle(
                                fontSize: 12.0,
                                color:
                                    isLightMode ? Colors.grey : Colors.white70,
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
                                ShopCubit.get(context)
                                    .changeFavorites(model.id);
                              },
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 16.0,
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
