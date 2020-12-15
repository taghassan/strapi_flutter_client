import 'package:bapp/classes/firebase_structures/bapp_user.dart';
import 'package:bapp/classes/location.dart';
import 'package:bapp/helpers/extensions.dart';
import 'package:bapp/route_manager.dart';
import 'package:bapp/screens/home/bapp.dart';
import 'package:bapp/screens/location/pick_a_location.dart';
import 'package:bapp/stores/cloud_store.dart';
import 'package:bapp/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class PickAPlaceScreen extends StatelessWidget {
  final Country country;
  const PickAPlaceScreen({this.country, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (country == null) {
      return _showCountries(context);
    }
    if (country != null) {
      return _showLocations(context);
    }
    throw FlutterError("only countries and location screen supported");
  }

  Widget _showCountries(BuildContext context) {
    return Consumer<CloudStore>(
      builder: (_, cloudStore, __) {
        return Observer(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text(
                  "Pick a Country",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              body: cloudStore.countries != null
                  ? ListView(
                      children: <Widget>[
                        ...cloudStore.countries.map(
                          (e) => ListTile(
                            title: Text(e.thePhoneNumber.country.englishName),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () async {
                              //cloudStore.getLocationsInCountry(e);
                              BappNavigator.push(context, PickAPlaceLocationScreen());
                            },
                          ),
                        ),
                      ],
                    )
                  : LoadingWidget(),
            );
          },
        );
      },
    );
  }

  Widget _showLocations(BuildContext context) {
    return Consumer<CloudStore>(
      builder: (context, cloudStore, __) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text(
              "Pick a City",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          body: Builder(
            builder: (_) {
              final cities = country.cities;
              return ListView(
                children: List.generate(
                  cities.length,
                  (index) => _getSubLocationWidget(
                    context,
                    cities[index],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _getSubLocationWidget(BuildContext context, City city) {
    return city.enabled
        ? Column(
            children: [
              ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text(
                  "All of ${city.name}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                onTap: () {
                  final cloudStore =
                      Provider.of<CloudStore>(context, listen: false);
                  cloudStore.bappUser = cloudStore.bappUser.updateWith(
                      address: Address(city: city.name, iso2: country.iso2));
                  cloudStore.bappUser.save();
                  BappNavigator.pushAndRemoveAll(context, Bapp());
                },
              ),
              ...List.generate(
                city.localities.length,
                (index) => ListTile(
                  trailing: Icon(Icons.arrow_forward_ios),
                  title: Text(city.localities[index].name,
                      style: Theme.of(context).textTheme.subtitle2),
                  onTap: () {
                    final cloudStore = context.read<CloudStore>();
                    cloudStore.bappUser = cloudStore.bappUser.updateWith(
                        address: Address(
                            iso2: country.iso2,
                            city: city.name,
                            locality: city.localities[index].name));
                    cloudStore.bappUser.save();
                    BappNavigator.pushAndRemoveAll(context, Bapp());
                  },
                ),
              ),
            ],
          )
        : SizedBox();
  }
}
