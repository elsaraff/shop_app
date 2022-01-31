import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/shop/cubit/shop_cubit.dart';
import 'package:shop_app/theme/cubit/theme_cubit.dart';
import 'package:shop_app/theme/cubit/theme_states.dart';
import 'package:shop_app/theme/theme.dart';
import 'package:shop_app/utilities/bloc_observer.dart';

import 'package:shop_app/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/login/login_screen.dart';
import 'package:shop_app/shop/shop_layout.dart';

import 'core/dio_helper.dart';
import 'core/cache_helper.dart';
import 'theme/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  DioHelper.init();

  await CacheHelper.init();
  bool isDark = CacheHelper.getBoolean(key: 'isDark');

  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');

  Widget startWidget;

  if (onBoarding != null) {
    if (token != null) {
      startWidget = const ShopLayout();
    } else {
      //token = null
      startWidget = const LoginScreen();
    }
  } else {
    //onBoarding = null
    startWidget = const OnBoardingScreen();
  }

  runApp(MyApp(
    startWidget: startWidget,
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  final bool isDark;

  const MyApp({Key key, this.startWidget, this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ShopCubit()
              ..getHomeData()
              ..getCategories()
              ..getFavorites()
              ..getUserData()),
        BlocProvider(
            create: (context) => ThemeCubit()..changeAppMode(fromShared: isDark)
            //..changeTextDirection(fromShared: isAr)
            ),
      ],
      child: BlocConsumer<ThemeCubit, ThemeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var themeCubit = ThemeCubit.get(context);

          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            themeMode:
                themeCubit.isLightMode ? ThemeMode.light : ThemeMode.dark,
            home: startWidget,
          );
        },
      ),
    );
  }
}
