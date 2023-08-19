import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/domain/favorites/entities/favorite_items.dart';
import 'package:netzoon/injection_container.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:netzoon/presentation/core/widgets/background_widget.dart';
import 'package:netzoon/presentation/favorites/favorite_blocs/favorites_bloc.dart';
import 'package:netzoon/presentation/utils/app_localizations.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key, required this.userId});
  final String userId;
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final favBloc = sl<FavoritesBloc>();

  @override
  void initState() {
    favBloc.add(GetFavoriteItemsEvent(userId: widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
            bloc: favBloc,
            builder: (context, state) {
              if (state is FavoriteItemsInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.backgroundColor,
                  ),
                );
              } else if (state is FavoriteItemsFailure) {
                final failure = state.message;
                return Center(
                  child: Text(
                    failure,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              } else if (state is FavoriteItemsSuccess) {
                return state.favoriteItems.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context).translate('no_items'),
                          style: TextStyle(
                            color: AppColor.backgroundColor,
                            fontSize: 22.sp,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.favoriteItems.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            state.favoriteItems[index].imageUrl,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 70.0, vertical: 50),
                                          child: CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                            color: AppColor.backgroundColor,

                                            // strokeWidth: 10,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                            ),
                                            child: Text(
                                              state.favoriteItems[index].name,
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColor.backgroundColor),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${state.favoriteItems[index].price} \$',
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColor
                                                          .backgroundColor),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    favBloc.add(RemoveItemFromFavoritesEvent(
                                                        product: FavoriteItems(
                                                            id: state
                                                                .favoriteItems[
                                                                    index]
                                                                .id,
                                                            name: state
                                                                .favoriteItems[
                                                                    index]
                                                                .name,
                                                            imageUrl: state
                                                                .favoriteItems[
                                                                    index]
                                                                .imageUrl,
                                                            description: state
                                                                .favoriteItems[
                                                                    index]
                                                                .description,
                                                            price: state
                                                                .favoriteItems[
                                                                    index]
                                                                .price,
                                                            category: state
                                                                .favoriteItems[
                                                                    index]
                                                                .category)));
                                                  },
                                                  icon: const Icon(
                                                    Icons.favorite,
                                                    color: AppColor.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
