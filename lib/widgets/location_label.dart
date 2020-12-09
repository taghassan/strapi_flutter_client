import 'package:bapp/route_manager.dart';
import 'package:bapp/stores/cloud_store.dart';
import 'package:bapp/widgets/store_provider.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class LocationLabelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteManager.pickAPlace);
      },
      child: Row(
        children: [
          Icon(
            FeatherIcons.mapPin,
            color: Theme.of(context).iconTheme.color,
            size: 16,
          ),
          SizedBox(
            width: 10,
          ),
          StoreProvider<CloudStore>(
            store: Provider.of<CloudStore>(context, listen: false),
            builder: (_, cloudStore) {
              return Observer(
                builder: (_) {
                  final bappUser = cloudStore.bappUser;
                  return Text(
                    bappUser.address.locality ??
                        bappUser.address.city,
                    style: Theme.of(context).textTheme.subtitle1,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
