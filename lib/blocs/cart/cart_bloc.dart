import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/cart/cart.dart';
import '../../repositories/item/item_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

///
class CartBloc extends Bloc<CartEvent, CartState> {
  ///
  CartBloc({@required ItemRepository itemRepository, FirebaseAuth firebaseAuth})
      : _itemRepository = itemRepository,
        _firebaseAuth = firebaseAuth ??
            // throws an error currentUser is null without FirebaseAuth.instance
            FirebaseAuth.instance,
        super(const CartState());

  ///
  final ItemRepository _itemRepository;

  ///
  StreamSubscription<List<CartItem>> _streamSubscription;

  ///
  final FirebaseAuth _firebaseAuth;

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is LoadCartItems) {
      yield* _mapLoadCartItemsToState();
    } else if (event is UpdateCartItems) {
      yield* _mapUpdateCartItemsToState(event);
    } else if (event is RemoveItemFromCart) {
      yield* _mapRemoveItemFromCartToState(event);
    } else if (event is AddItemToCart) {
      yield* _mapAddItemToCartToState(event);
    }
  }

  ///
  Stream<CartState> _mapLoadCartItemsToState() async* {
    await _streamSubscription?.cancel();

    _streamSubscription = _itemRepository
        .currentUserCartItems()
        .listen((items) => add(UpdateCartItems(cartItems: items)));
  }

  Stream<CartState> _mapUpdateCartItemsToState(UpdateCartItems event) async* {
    yield LoadingCartItems();

    try {
      yield CartItemsLoaded(cartItems: event.cartItems);
    } on Exception catch (_) {}
  }

  ///
  Stream<CartState> _mapAddItemToCartToState(AddItemToCart event) async* {
    yield AddingItemToCart();

    try {
      final newCartItem = CartItem(
          id: event.cartItem.id,
          buyerId: _firebaseAuth.currentUser.uid,
          sellerId: event.cartItem.sellerId,
          title: event.cartItem.title,
          mainImageUrl: event.cartItem.mainImageUrl,
          price: event.cartItem.price,
          timestamp: Timestamp.now());

      await _itemRepository.addItemToCart(newCartItem);

      yield ItemSuccessfullyAddedToCart();
    } on Exception catch (_) {}
  }

  ///
  Stream<CartState> _mapRemoveItemFromCartToState(
      RemoveItemFromCart event) async* {
    yield ItemBeingRemovedFromCart();

    try {
      await _itemRepository.removeItemFromCart(event.item);
    } on Exception catch (_) {}
  }
}
