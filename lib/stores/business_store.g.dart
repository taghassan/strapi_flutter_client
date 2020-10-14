// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BusinessStore on _BusinessStore, Store {
  final _$categoriesAtom = Atom(name: '_BusinessStore.categories');

  @override
  ObservableList<BusinessCategory> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(ObservableList<BusinessCategory> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  final _$businessAtom = Atom(name: '_BusinessStore.business');

  @override
  BusinessDetails get business {
    _$businessAtom.reportRead();
    return super.business;
  }

  @override
  set business(BusinessDetails value) {
    _$businessAtom.reportWrite(value, super.business, () {
      super.business = value;
    });
  }

  final _$_userAtom = Atom(name: '_BusinessStore._user');

  @override
  User get _user {
    _$_userAtom.reportRead();
    return super._user;
  }

  @override
  set _user(User value) {
    _$_userAtom.reportWrite(value, super._user, () {
      super._user = value;
    });
  }

  final _$applyForBusinessAsyncAction =
      AsyncAction('_BusinessStore.applyForBusiness');

  @override
  Future<dynamic> applyForBusiness(BusinessDetails ap) {
    return _$applyForBusinessAsyncAction.run(() => super.applyForBusiness(ap));
  }

  final _$getMyBusinessAsyncAction =
      AsyncAction('_BusinessStore.getMyBusiness');

  @override
  Future<dynamic> getMyBusiness(BusinessDetails ap) {
    return _$getMyBusinessAsyncAction.run(() => super.getMyBusiness(ap));
  }

  final _$getCategoriesAsyncAction =
      AsyncAction('_BusinessStore.getCategories');

  @override
  Future<dynamic> getCategories() {
    return _$getCategoriesAsyncAction.run(() => super.getCategories());
  }

  @override
  String toString() {
    return '''
categories: ${categories},
business: ${business}
    ''';
  }
}
