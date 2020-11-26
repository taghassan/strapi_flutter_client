// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CloudStore on _CloudStore, Store {
  Computed<TheNumber> _$theNumberComputed;

  @override
  TheNumber get theNumber =>
      (_$theNumberComputed ??= Computed<TheNumber>(() => super.theNumber,
              name: '_CloudStore.theNumber'))
          .value;

  final _$myAddressAtom = Atom(name: '_CloudStore.myAddress');

  @override
  MyAddress get myAddress {
    _$myAddressAtom.reportRead();
    return super.myAddress;
  }

  @override
  set myAddress(MyAddress value) {
    _$myAddressAtom.reportWrite(value, super.myAddress, () {
      super.myAddress = value;
    });
  }

  final _$countriesAtom = Atom(name: '_CloudStore.countries');

  @override
  List<Country> get countries {
    _$countriesAtom.reportRead();
    return super.countries;
  }

  @override
  set countries(List<Country> value) {
    _$countriesAtom.reportWrite(value, super.countries, () {
      super.countries = value;
    });
  }

  final _$userTypeAtom = Atom(name: '_CloudStore.userType');

  @override
  UserType get userType {
    _$userTypeAtom.reportRead();
    return super.userType;
  }

  @override
  set userType(UserType value) {
    _$userTypeAtom.reportWrite(value, super.userType, () {
      super.userType = value;
    });
  }

  final _$alterEgoAtom = Atom(name: '_CloudStore.alterEgo');

  @override
  UserType get alterEgo {
    _$alterEgoAtom.reportRead();
    return super.alterEgo;
  }

  @override
  set alterEgo(UserType value) {
    _$alterEgoAtom.reportWrite(value, super.alterEgo, () {
      super.alterEgo = value;
    });
  }

  final _$userAtom = Atom(name: '_CloudStore.user');

  @override
  User get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$statusAtom = Atom(name: '_CloudStore.status');

  @override
  AuthStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(AuthStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$loadingForOTPAtom = Atom(name: '_CloudStore.loadingForOTP');

  @override
  bool get loadingForOTP {
    _$loadingForOTPAtom.reportRead();
    return super.loadingForOTP;
  }

  @override
  set loadingForOTP(bool value) {
    _$loadingForOTPAtom.reportWrite(value, super.loadingForOTP, () {
      super.loadingForOTP = value;
    });
  }

  final _$switchUserTypeAsyncAction = AsyncAction('_CloudStore.switchUserType');

  @override
  Future<bool> switchUserType(BuildContext context) {
    return _$switchUserTypeAsyncAction.run(() => super.switchUserType(context));
  }

  final _$getMyUserTypesAsyncAction = AsyncAction('_CloudStore.getMyUserTypes');

  @override
  Future<dynamic> getMyUserTypes() {
    return _$getMyUserTypesAsyncAction.run(() => super.getMyUserTypes());
  }

  final _$getMyAddressAsyncAction = AsyncAction('_CloudStore.getMyAddress');

  @override
  Future<dynamic> getMyAddress() {
    return _$getMyAddressAsyncAction.run(() => super.getMyAddress());
  }

  final _$getActiveCountriesAsyncAction =
      AsyncAction('_CloudStore.getActiveCountries');

  @override
  Future<dynamic> getActiveCountries() {
    return _$getActiveCountriesAsyncAction
        .run(() => super.getActiveCountries());
  }

  final _$signOutAsyncAction = AsyncAction('_CloudStore.signOut');

  @override
  Future<dynamic> signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  @override
  String toString() {
    return '''
myAddress: ${myAddress},
countries: ${countries},
userType: ${userType},
alterEgo: ${alterEgo},
user: ${user},
status: ${status},
loadingForOTP: ${loadingForOTP},
theNumber: ${theNumber}
    ''';
  }
}
