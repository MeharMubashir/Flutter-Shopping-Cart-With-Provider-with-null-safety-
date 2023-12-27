import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart'as badges;

import 'cart_model.dart';
import 'cart_provider.dart';
import 'db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text('My Products'),
        actions: [
          badges.Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context,value,child){
                return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white));
              },
            ),
            child: Icon(Icons.shopping_bag_outlined),
            badgeAnimation: badges.BadgeAnimation.scale(animationDuration: Duration(microseconds: 300)),

          ),
          SizedBox(width: 20,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData() ,
                builder: (context,AsyncSnapshot<List<Cart>> snapshot){
             if(snapshot.hasData){
               if(snapshot.data!.isEmpty){
                 return  Column(

                     children: [
                       Center(child: Image(image: AssetImage('images/image.png'))),
                       SizedBox(height: 5,),
                       Center(child: Text('Your Cart Is Empty!\nExplore Produtcs',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),))],);

               }else{
                 return Expanded(
                     child:ListView.builder(
                         itemCount: snapshot.data!.length,
                         itemBuilder: (context,index){
                           return Card(child:
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [

                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisSize: MainAxisSize.max,
                                   children: [
                                     Image(
                                       height: 100,
                                       width: 100,
                                       image: NetworkImage(snapshot.data![index].image.toString()),
                                     ),
                                     SizedBox(height: 10,),
                                     Expanded(
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Text(snapshot.data![index].productName.toString(),style:TextStyle(fontSize: 16,fontWeight:FontWeight.w500) ,),
                                               InkWell(
                                                   onTap: (){
                                                     dbHelper!.delete(snapshot.data![index].id!);
                                                     cart.removeCounter();
                                                     cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                   },
                                                   child: Icon(Icons.delete))
                                             ],),

                                           SizedBox(height: 5,),
                                           Text(snapshot.data![index].unitTag.toString() +" "+r"$"+ snapshot.data![index].productPrice.toString()
                                             ,style:TextStyle(fontSize: 16,fontWeight:FontWeight.w500) ,),

                                           Align(
                                             alignment: Alignment.centerRight,
                                             child: InkWell(
                                               onTap: (){

                                               },
                                               child: Container(
                                                 width: 100,
                                                 height: 35,
                                                 decoration: BoxDecoration(
                                                     color: Colors.green,
                                                     borderRadius:BorderRadius.circular(5)
                                                 ),
                                                 child: Padding(
                                                   padding: const EdgeInsets.all(4.0),
                                                   child: Row(
                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                     children: [
                                                       InkWell(
                                                           onTap:(){
                                                             int quantity =snapshot.data![index].quantity!;
                                                             int price =snapshot.data![index].initialPrice!;
                                                             quantity--;
                                                             int? newPrice = price*quantity;
                                                             if(quantity >0){
                                                               dbHelper!.updateQuantity(
                                                                   Cart(
                                                                       id: snapshot.data![index].id!,
                                                                       productId: snapshot.data![index].id!.toString(),
                                                                       productName: snapshot.data![index].productName!,
                                                                       initialPrice:snapshot.data![index].initialPrice!,
                                                                       productPrice: newPrice,
                                                                       quantity: quantity,
                                                                       unitTag: snapshot.data![index].unitTag!.toString(),
                                                                       image: snapshot.data![index].image.toString())
                                                               ).then((value){
                                                                 newPrice =0;
                                                                 quantity =0;
                                                                 cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                               }).onError((error, stackTrace){
                                                                 print(error.toString());
                                                               });
                                                             }

                                                           },
                                                           child: Icon(Icons.remove,color: Colors.white,)),
                                                       Text(snapshot.data![index].quantity.toString(),style: TextStyle(color: Colors.white),),
                                                       InkWell(
                                                           onTap:(){
                                                             int quantity =snapshot.data![index].quantity!;
                                                             int price =snapshot.data![index].initialPrice!;
                                                             quantity++;
                                                             int? newPrice = price*quantity;
                                                             dbHelper!.updateQuantity(
                                                                 Cart(
                                                                     id: snapshot.data![index].id!,
                                                                     productId: snapshot.data![index].id!.toString(),
                                                                     productName: snapshot.data![index].productName!,
                                                                     initialPrice:snapshot.data![index].initialPrice!,
                                                                     productPrice: newPrice,
                                                                     quantity: quantity,
                                                                     unitTag: snapshot.data![index].unitTag!.toString(),
                                                                     image: snapshot.data![index].image.toString())
                                                             ).then((value){
                                                               newPrice =0;
                                                               quantity =0;
                                                               cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                             }).onError((error, stackTrace){
                                                               print(error.toString());
                                                             });
                                                           },
                                                           child: Icon(Icons.add,color: Colors.white,)),
                                                     ],
                                                   ),
                                                 ),),
                                             ),
                                           )
                                         ],

                                       ),
                                     )

                                   ],)
                               ],),
                           ),);
                         })  );
               }

             }
             return Text('');
            }),
            Consumer<CartProvider>(builder: (context,value,child){
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"? false:true,
                child: Column(children: [

                    ReuseableWidget(title: 'SubTotal', value: r'$'+value.getTotalPrice().toStringAsFixed(2)),

                ],),
              );
            })
          ],
        ),
      ),
    );
  }
}


class ReuseableWidget extends StatelessWidget {
  final String title, value;
  const ReuseableWidget({required this.title,required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style:Theme.of(context).textTheme.subtitle2),
          Text(value.toString(),style:Theme.of(context).textTheme.subtitle2),
        ],
      ),
    );
  }
}