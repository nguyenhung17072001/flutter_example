import 'package:example/flow/blocs/order_bloc.dart';
import 'package:example/flow/state/order_state.dart';
import 'package:example/src/models/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<OrderScreen> {
  late List<Food> foods;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final OrderBloc orderBloc = BlocProvider.of<OrderBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Order'),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(45, 182, 163, 100),
          //iconTheme: const IconThemeData(color: Colors.black),
          //actions: [],
          automaticallyImplyLeading: false,
          elevation: 0.0,
        ),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderStateSuccess) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: state.foods.map((food) {
                          return Container(
                            margin: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: Image.asset(food.image)
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                      Text(food.name),
                                      Text('Price: \$${food.price}')
                                    ],
                                  ),
                                )
                              ]
                            ),
                           
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text("You have not ordered any products yet"),
              );
            }
          },
        ));
  }
}