import 'package:bapp/config/config.dart';
import 'package:bapp/route_manager.dart';
import 'package:bapp/stores/business_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'package:bapp/stores/auth_store.dart';
import 'search_bar.dart';
import 'store_provider.dart';

class DiscoverTab extends StatefulWidget {
  @override
  _DiscoverTabState createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AuthStore>(
      store: context.watch<AuthStore>(),
      builder: (_, authStore) {
        return Observer(builder: (_) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text("Hey User"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "What can we help you book?",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _getSearchBar(),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Or Browse Categories"),
                    SizedBox(
                      height: 10,
                    ),
                    _getCategoriesScroller(context),
                    SizedBox(
                      height: 20,
                    ),
                    _getFeaturedScroller(context),
                    if (authStore.status == AuthStatus.userPresent)
                      _getCompleteOrder(context),
                    if (authStore.status == AuthStatus.userPresent)
                      _getHowWasYourExperience(context),
                    SizedBox(
                      height: 20,
                    ),
                    _getOwnABusiness(context),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _getSearchBar(){
    return StoreProvider<BusinessStore>(
      store: Provider.of<BusinessStore>(context),
      init: (businessStore) async {
        await businessStore.getCategories();
      },
      builder: (_, businessStore) {
        return Observer(
          builder: (_) {
            return SearchBarWidget(
              possibilities: Provider.of<BusinessStore>(context,
                  listen: false)
                  .categories
                  .map<String>(
                    (element) => element.normalName,
              )
                  .toList(),
            );
          },
        );
      },
    );
  }

  Widget _getOwnABusiness(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: CardsColor.colors["purple"],
          borderRadius: BorderRadius.circular(6)),
      child: ListTile(
        onTap: () {
          Navigator.of(context)
              .pushNamed(RouteManager.selectBusinessCategoryScreen);
        },
        title: Text(
          "Own A Business",
          style: Theme.of(context).textTheme.subtitle1.apply(
                color: Theme.of(context).primaryColorLight,
              ),
        ),
        subtitle: Text(
          "List your business on Bapp",
          style: Theme.of(context).textTheme.bodyText1.apply(
                color: Theme.of(context).primaryColorLight,
              ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }

  Widget _getHowWasYourExperience(BuildContext context) {
    return SizedBox();
  }

  Widget _getCompleteOrder(BuildContext context) {
    return SizedBox();
  }

  Widget _getFeaturedScroller(context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...HomeScreenFeaturedConfig.slides.map(
            (e) => Container(
              height: 125,
              width: 142,
              margin: EdgeInsets.only(right: 20),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: e.cardColor, borderRadius: BorderRadius.circular(6)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    e.icon,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    e.title,
                    style: Theme.of(context).textTheme.headline3.apply(
                          color: Theme.of(context).primaryColorLight,
                        ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getCategoriesScroller(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FlatButton(
            onPressed: () {},
            child: Text(
              "Mock",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Text(
              "mock two",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Text(
              "Mock 3",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Text(
              "Mock",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Text(
              "Mock",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}
