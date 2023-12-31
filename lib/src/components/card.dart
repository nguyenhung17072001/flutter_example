import 'package:example/flow/blocs/order_bloc.dart';
import 'package:example/flow/events/order_event.dart';
import 'package:example/src/models/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/food_detail.dart';


class HomeCard extends StatefulWidget {
  final Map? item;
  
  
  HomeCard({this.item});

  @override
  State<StatefulWidget> createState() {
    return _HomeCardState();
  }

}


class _HomeCardState extends State<HomeCard> {
  late Map _item;
  late bool isFavourite;
  
  @override
  void initState() {
    super.initState();
    _item = widget.item!;
    isFavourite = false;
  }

  handleLike() {
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //print(_item);
    return Container(
      //height: 500,
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      width: screenWidth*0.45,
      child: Material(
        elevation: 2,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: handleLike, 
                  child: Icon(
                    isFavourite? CupertinoIcons.heart_fill: CupertinoIcons.heart, 
                    color: Colors.red,
                  )
                ),
              ],
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FoodDetail(params: _item)),
                  );
                },
                child: Image.asset(_item['image'])
              ),
            ),
            Text(_item['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_item['price']),
                  IconButton(
                    onPressed: () {
                      context.read<OrderBloc>().add(OrderEvent(Food(id: _item['id'], name: _item['name'], image: _item['image'], price: _item['price'])));
                    }, 
                    icon: const Icon(CupertinoIcons.plus_circle, color: Color.fromRGBO(45, 182, 163, 100),)
                  )
                ],
              ),
            ),
            
          ]
        ),
      ),
    );
  }

}
