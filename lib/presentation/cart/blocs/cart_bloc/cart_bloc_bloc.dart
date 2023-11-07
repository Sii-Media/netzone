import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';

part 'cart_bloc_event.dart';
part 'cart_bloc_state.dart';

class CartBlocBloc extends Bloc<CartBlocEvent, CartBlocState> {
  CartBlocBloc() : super(CartBlocInitial()) {
    on<LoadCart>(
      (event, emit) => emit(
        const CartLoaded(
          items: [],
          totalPrice: 0,
          totalQuantity: 0,
          totalWeight: 0,
        ),
      ),
    );
    on<AddToCart>(
      (event, emit) {
        final updatedCart = List<CategoryProducts>.from(state.props)
          ..add(event.product);
        final totalPrice = calculateTotalPrice(updatedCart);
        final totalQuantity = calculateTotalQuantity(updatedCart);
        final totalWeight = calculateTotalWeight(updatedCart);
        emit(
          CartLoaded(
            items: updatedCart,
            totalPrice: totalPrice,
            totalQuantity: totalQuantity,
            totalWeight: totalWeight,
          ),
        );
      },
    );
    on<RemoveFromCart>((event, emit) {
      final updatedCart = List<CategoryProducts>.from(state.props)
        ..remove(event.product);
      final totalPrice = calculateTotalPrice(updatedCart);
      final totalQuantity = calculateTotalQuantity(updatedCart);
      final totalWeight = calculateTotalWeight(updatedCart);
      emit(
        CartLoaded(
            items: updatedCart,
            totalPrice: totalPrice,
            totalQuantity: totalQuantity,
            totalWeight: totalWeight),
      );
    });

    on<ChangeQuantity>(
      (event, emit) {
        final updatedCart = List<CategoryProducts>.from(state.props);
        final index = updatedCart.indexWhere((item) => item == event.product);

        if (index != -1) {
          if (event.cartQty > updatedCart[index].quantity!) {
            final totalPrice = calculateTotalPrice(updatedCart);
            final totalQuantity = calculateTotalQuantity(updatedCart);
            final totalWeight = calculateTotalWeight(updatedCart);
            emit(
              CartLoaded(
                items: updatedCart,
                totalPrice: totalPrice,
                totalQuantity: totalQuantity,
                outStock: true,
                totalWeight: totalWeight,
              ),
            );
          }
          final updatedItem = CategoryProducts(
            id: event.product.id,
            owner: event.product.owner,
            name: event.product.name,
            imageUrl: event.product.imageUrl,
            category: event.product.category,
            condition: event.product.condition,
            description: event.product.description,
            price: event.product.price,
            weight: event.product.weight,
            images: event.product.images,
            vedioUrl: event.product.vedioUrl,
            guarantee: event.product.guarantee,
            propert: event.product.propert,
            madeIn: event.product.madeIn,
            year: event.product.year,
            quantity: event.product.quantity,
            cartQty: event.cartQty,
            country: event.product.country,
          );
          updatedCart[index] = updatedItem;
          final totalPrice = calculateTotalPrice(updatedCart);
          final totalQuantity = calculateTotalQuantity(updatedCart);
          final totalWeight = calculateTotalWeight(updatedCart);
          emit(
            CartLoaded(
              items: updatedCart,
              totalPrice: totalPrice,
              totalQuantity: totalQuantity,
              totalWeight: totalWeight,
            ),
          );
        }
      },
    );
    on<ClearCart>(
      (event, emit) {
        emit(
          const CartLoaded(
            totalWeight: 0,
            items: [],
            totalPrice: 0,
            totalQuantity: 0,
          ),
        );
      },
    );
  }
  double calculateTotalWeight(List<CategoryProducts> cartItems) {
    double totalWeight = 0;
    for (var item in cartItems) {
      print('aaaaaaaaaaaa');
      print(item.cartQty ?? 1);
      if (item.cartQty == null) {
        totalWeight = totalWeight + item.weight! * 1;
      } else {
        totalWeight = totalWeight + (item.weight! * item.cartQty!);
      }
    }
    return totalWeight;
  }

  double calculateTotalPrice(List<CategoryProducts> cartItems) {
    double totalPrice = 0;
    for (var item in cartItems) {
      if (item.priceAfterDiscount == null) {
        if (item.cartQty == null) {
          totalPrice += item.price * 1;
        } else {
          totalPrice += item.price * item.cartQty!;
        }
      } else {
        if (item.cartQty == null) {
          totalPrice += item.priceAfterDiscount! * 1;
        } else {
          totalPrice += item.priceAfterDiscount! * item.cartQty!;
        }
      }
    }
    return totalPrice;
  }

  num calculateTotalQuantity(List<CategoryProducts> cartItems) {
    num totalQuantity = 0;
    for (var item in cartItems) {
      totalQuantity += item.cartQty ?? 1;
    }
    return totalQuantity;
  }
}
