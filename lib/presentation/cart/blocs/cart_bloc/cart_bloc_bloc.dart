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
        ),
      ),
    );
    on<AddToCart>(
      (event, emit) {
        final updatedCart = List<CategoryProducts>.from(state.props)
          ..add(event.product);
        final totalPrice = calculateTotalPrice(updatedCart);
        final totalQuantity = calculateTotalQuantity(updatedCart);
        emit(
          CartLoaded(
            items: updatedCart,
            totalPrice: totalPrice,
            totalQuantity: totalQuantity,
          ),
        );
      },
    );
    on<RemoveFromCart>((event, emit) {
      final updatedCart = List<CategoryProducts>.from(state.props)
        ..remove(event.product);
      final totalPrice = calculateTotalPrice(updatedCart);
      final totalQuantity = calculateTotalQuantity(updatedCart);
      emit(
        CartLoaded(
          items: updatedCart,
          totalPrice: totalPrice,
          totalQuantity: totalQuantity,
        ),
      );
    });

    on<ChangeQuantity>(
      (event, emit) {
        final updatedCart = List<CategoryProducts>.from(state.props);
        final index = updatedCart.indexWhere((item) => item == event.product);

        if (index != -1) {
          final updatedItem = CategoryProducts(
            id: event.product.id,
            owner: event.product.owner,
            name: event.product.name,
            imageUrl: event.product.imageUrl,
            category: event.product.category,
            description: event.product.description,
            price: event.product.price,
            images: event.product.images,
            vedioUrl: event.product.vedioUrl,
            guarantee: event.product.guarantee,
            propert: event.product.propert,
            madeIn: event.product.madeIn,
            year: event.product.year,
            quantity: event.quantity,
          );
          updatedCart[index] = updatedItem;
        }

        final totalPrice = calculateTotalPrice(updatedCart);
        final totalQuantity = calculateTotalQuantity(updatedCart);
        emit(
          CartLoaded(
              items: updatedCart,
              totalPrice: totalPrice,
              totalQuantity: totalQuantity),
        );
      },
    );
  }
  double calculateTotalPrice(List<CategoryProducts> cartItems) {
    double totalPrice = 0;
    for (var item in cartItems) {
      if (item.quantity == null) {
        totalPrice += item.price * 1;
      } else {
        totalPrice += item.price * item.quantity!;
      }
    }
    return totalPrice;
  }

  num calculateTotalQuantity(List<CategoryProducts> cartItems) {
    num totalQuantity = 0;
    for (var item in cartItems) {
      totalQuantity += item.quantity ?? 1;
    }
    return totalQuantity;
  }
}
