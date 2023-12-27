import 'package:cart/cart_model.dart';
import 'package:cart/cart_provider.dart';
import 'package:cart/cart_screen.dart';
import 'package:cart/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart'as badges;
import 'package:provider/provider.dart';
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DBHelper? dbHelper = DBHelper();
  List<String> productName = ['Mango','Orange','Grapes','Banana','Apple','Cherry','Peach'];
  List<String> productUnit = ['KG','Dozen','KG','Dozen','KG','KG','KG'];
  List<int> productPrice = [10 ,20, 40, 30, 15, 25, 35];
  List<String> productImage =[
    'https://icons.iconarchive.com/icons/iconarchive/realistic-illustration-fruit/256/Mango-Illustration-icon.png',
     'https://icons.iconarchive.com/icons/gcds/chinese-new-year/256/orange-icon.png',
    'https://icons.iconarchive.com/icons/iconarchive/fruit-illustration/256/Grape-Illustration-icon.png',
    'https://icons.iconarchive.com/icons/iconarchive/fruit-soft-illustration/256/Banana-icon.png',
    'https://icons.iconarchive.com/icons/bingxueling/fruit-vegetables/256/apple-red-icon.png',
    'https://icons.iconarchive.com/icons/iconarchive/realistic-fruits/256/Cherry-icon.png',
    'https://icons.iconarchive.com/icons/iconarchive/realistic-fruits/256/Peach-icon.png'

  ];
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text('Product List'),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                  badgeContent: Consumer<CartProvider>(
                   builder: (context,value,child){
                    return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white));
                   },
                      ),
                  child: Icon(Icons.shopping_bag_outlined),
                  badgeAnimation: badges.BadgeAnimation.scale(animationDuration: Duration(microseconds: 300)),

              ),
            ),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: Column(children: [
        Expanded(
          child:ListView.builder(
              itemCount: productName.length,
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
                    image: NetworkImage(productImage[index].toString()),
                  ),
                    SizedBox(height: 10,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(productName[index].toString(),style:TextStyle(fontSize: 16,fontWeight:FontWeight.w500) ,),
                      SizedBox(height: 5,),
                      Text(productUnit[index].toString() +" "+r"$"+ productPrice[index].toString()
                        ,style:TextStyle(fontSize: 16,fontWeight:FontWeight.w500) ,),

                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: (){
                            dbHelper?.insert(
                              Cart(
                                  id: index,
                                  productId: index.toString(),
                                  productName: productName[index].toString(),
                                  initialPrice: productPrice[index],
                                  productPrice: productPrice[index],
                                  quantity: 1,
                                  unitTag: productUnit[index].toString(),
                                  image: productImage[index].toString())

                            ).then((value){
                             print('Product Is Added To Cart');
                             cart.addTotalPrice(double.parse(productPrice[index].toString()));
                             cart.addCounter();
                            }).onError((error, stackTrace){
                              print(error.toString());
                            });
                            },
                            child: Container(
                              width: 100,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:BorderRadius.circular(5)
                              ),
                              child: Center(
                              child: Text('Add to Cart',style: TextStyle(color: Colors.white),),
                            ),),
                          ),
                        )
                    ],

                    ),
                  )

                ],)
                ],),
              ),);
          })

        ),

      ],),
    );
  }
}

