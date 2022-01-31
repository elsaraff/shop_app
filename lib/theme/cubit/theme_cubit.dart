import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/core/cache_helper.dart';
import 'package:shop_app/theme/cubit/theme_states.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(ThemeInitialState());

  static ThemeCubit get(context) => BlocProvider.of(context);

  bool isLightMode = false;

  void changeAppMode({bool fromShared}) {
    if (fromShared != null) {
      isLightMode = fromShared;
    } else {
      isLightMode = !isLightMode;
      CacheHelper.setBoolean(key: 'isDark', value: isLightMode)
          .then((value) {});
      emit(ThemeChangeModeState());
    }
  }
}
