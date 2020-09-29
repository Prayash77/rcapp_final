import 'package:badges/badges.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rcapp/models/user.dart';
import 'package:rcapp/pages/CategoryMenuList/flushbar.dart';
import 'package:rcapp/pages/storeData.dart';
import 'package:provider/provider.dart';
import 'package:rcapp/services/database.dart';

class Roll_MenuList extends StatefulWidget {
  @override
  _Roll_MenuListState createState() => _Roll_MenuListState();
}

class _Roll_MenuListState extends State<Roll_MenuList> {
  StoreData dataforCart = StoreData();
  int total = 0;

  int qty = 0;

  void updateTotal() {
    Map<String, int> qtyDetail = dataforCart.retrieveQtyDetails();

    total = 0;
    qty = 0;

    setState(() {
      qtyDetail.forEach((key, value) {
        ++qty;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateTotal();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<RollMenu>>.value(
      value: DatabaseService().rollmenu,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text('Roll'),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
                icon: Badge(
                  toAnimate: true,
                  badgeColor: Colors.yellow,
                  badgeContent: Text('$qty'),
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: RollMenuListListPage(updateTotal: updateTotal),
            )
          ],
        ),
      ),
    );
  }
}

class RollMenuListListPage extends StatefulWidget {
  final updateTotal;
  RollMenuListListPage({this.updateTotal});
  @override
  _RollMenuListListPageState createState() => _RollMenuListListPageState();
}

class _RollMenuListListPageState extends State<RollMenuListListPage> {
  StoreData storeData = StoreData();
  int total = 0;
  bool checked = false;
  Map<String, int> quantityDetail = Map<String, int>();
  int qty = 0;
  List<int> qtyList = List<int>();

  void updateTotal() {
    Map<String, int> foodDetail = storeData.retrieveFoodDetails();
    Map<String, int> qtyDetail = storeData.retrieveQtyDetails();

    total = 0;

    setState(() {
      qtyDetail.forEach((key, value) => qtyList.add(value));
      foodDetail.forEach((k, v) => total = total + v * qtyDetail[k]);
    });
  }

  void quantityIncreement(String foodName) {
    storeData.increaseQty(foodName);
    updateTotal();
  }

  void quantityDecreement(String foodName) {
    storeData.decreaseQty(foodName);
    updateTotal();
  }

  void update() {
    Map<String, int> qtyCart = storeData.retrieveQtyDetails();
    Map<String, int> foodDetail = storeData.retrieveFoodDetails();

    setState(() {
      qty = 0;
      qtyCart.forEach((key, value) {
        qty += value;
        qtyList.add(value);
      });
      foodDetail.forEach((k, v) => total = total + v * qtyCart[k]);
    });
  }

  void addToCart(RollMenu post) {
    String item = post.item;
    int price = post.price;

    Map<String, int> qtyDetail = storeData.retrieveQtyDetails();

    int qty = 1;

    qtyDetail.forEach((key, value) {
      if (key == item) {
        qty = value;
      }
    });

    if (qty > 1) {
      storeData.StoreFoodDetails(item, price, qty);
    } else {
      storeData.StoreFoodDetails(item, price, 1);
    }
    print(item);
  }

  @override
  Widget build(BuildContext context) {
    final _menuList = Provider.of<List<RollMenu>>(context) ?? [];
    if (_menuList.length != 0) {
      _menuList.sort((a, b) => a.searchIndex.compareTo(b.searchIndex));
    }
    if (_menuList.length == 0) {
      return Container(
        height: 200,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitDualRing(
                color: Colors.deepOrange,
                size: 38,
              ),
              SizedBox(height: 20),
              Text('LOADING', style: TextStyle(fontWeight: FontWeight.w500))
            ]),
      );
    } else {
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _menuList.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 15),
                                    Text(
                                      '${_menuList[index].item}',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    addToCart(_menuList[index]);
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 43,
                                    margin: EdgeInsets.only(top: 6),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrange,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: IconButton(
                                      onPressed: () {
                                        showFlushbar(context);
                                        addToCart(_menuList[index]);
                                        setState(() {
                                          checked = !checked;
                                        });
                                        widget.updateTotal();
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: new EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 16.0),
                                  child: Text(
                                    '₹' + '${_menuList[index].price}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              height: 2,
                              thickness: 1,
                              indent: 5,
                              endIndent: 5,
                            ),
                          ],
                        ),
                      );
                    })),
          )
        ],
      );
    }
  }
}
