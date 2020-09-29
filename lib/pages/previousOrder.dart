import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rcapp/models/user.dart';

class PreviousOrder extends StatefulWidget {
  @override
  _PreviousOrderState createState() => _PreviousOrderState();
}

class _PreviousOrderState extends State<PreviousOrder> {
  List<dynamic> orders = [];
  List<dynamic> item = [];
  List<dynamic> quantity = [];
  List<dynamic> total = [];
  var _result = 1;

  void initialData() async {
    var uid = (await FirebaseAuth.instance.currentUser()).uid;
    print(uid);
    var result = await Firestore.instance
        .collection('confirmedOrders')
        .where('id', isEqualTo: uid)
        .getDocuments();
    setState(() {
      _result = result.documents.length;
    });
    result.documents.forEach((res) {
      setState(() {
        orders.add(res.data);
        item.add(res.data["item"]);
        quantity.add(res.data["quantity"]);
        total.add(res.data["total"]);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialData();
  }

  @override
  Widget build(BuildContext context) {
    int orderNo = 110;
    if (orders.length == 0 &&
        item.length == 0 &&
        quantity.length == 0 &&
        _result == 1) {
      return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              SpinKitCircle(color: Colors.deepOrange, size: 65),
              Text('Loading data')
            ])),
      );
    }
    if (_result == 0) {
      return Scaffold(
        appBar: AppBar(
            title: Text('Previous Orders'), backgroundColor: Colors.deepOrange),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Icon(Icons.add_shopping_cart, size: 40, color: Colors.deepOrange),
              Text('No Previous Order Pending',
                  style: GoogleFonts.inter(
                      color: Colors.black, fontWeight: FontWeight.bold))
            ])),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
          backgroundColor: Colors.deepOrange,
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: orders.length,
            itemBuilder: (_, index) {
              orderNo += index;
              return ListTile(
                contentPadding: EdgeInsets.all(10),
                title: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: 370.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          border: Border.all(color: Colors.grey)),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "#$orderNo",
                                style: GoogleFonts.inter(
                                    color: Colors.deepOrange, fontSize: 22),
                              ),
                              Flexible(child: Text('${orders[index]["date"]}')),
                            ],
                          ),
                          SizedBox(height: 8),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Name : " + "${orders[index]["name"]}",
                                      style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ]),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Text(
                                "Mobile No: ${orders[index]["mobileNumber"]}",
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(children: <Widget>[
                            Text(
                              "Status : ",
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                            if (!orders[index]["isConfirmed"] && !orders[index]["isRejected"]) ...[
                              Text(
                                "Not Confirmed",
                                style: GoogleFonts.inter(
                                    color: Colors.orange,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ] else if(orders[index]["isRejected"])...[
                              Text(
                                "Rejected",
                                style: GoogleFonts.inter(
                                    color: Colors.red[800],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ] else ...[
                              Text(
                                "Confirmed",
                                style: GoogleFonts.inter(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]
                          ]),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Cost : ₹" + "${orders[index]["total"]} ",
                                  style: GoogleFonts.inter(
                                      color: Colors.black, fontSize: 22),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PreviousOrderDetails(
                                                    total: orders[index]
                                                        ["total"],
                                                    orderNo: orderNo,
                                                    name: orders[index]["name"],
                                                    date: orders[index]["date"],
                                                    number: orders[index]
                                                        ["number"],
                                                    address: orders[index]
                                                        ["address"],
                                                    item: item[index],
                                                    quantity: quantity[index],
                                                    mobileNumber: orders[index]
                                                        ["mobileNumber"],
                                                    price: orders[index]
                                                        ["price"])));
                                  },
                                  child: Container(
                                    child: Text('Know More',
                                        style: GoogleFonts.inter(
                                            color: Colors.deepOrange,
                                            decoration:
                                                TextDecoration.underline)),
                                  ),
                                )
                              ]),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }
}

class OrderData extends StatefulWidget {
  List item;
  List quantity;
  List price;
  OrderData({this.item, this.quantity, this.price});
  @override
  _OrderDataState createState() => _OrderDataState();
}

class _OrderDataState extends State<OrderData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
      height: 290,
      child: ListView.builder(
          itemCount: widget.item.length,
          itemBuilder: (_, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    // decoration: BoxDecoration(color: Colors.deepOrange),
                    width: MediaQuery.of(context).size.width * 0.34,
                    child: Text(
                      '${widget.item[index]}',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    )),
                Container(
                    // decoration: BoxDecoration(color: Colors.deepOrange),
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      '${widget.quantity[index]}',
                      textAlign: TextAlign.center,
                    )),
                Container(
                    // decoration: BoxDecoration(color: Colors.deepOrange),
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      '${widget.price[index]}',
                      textAlign: TextAlign.center,
                    )),
              ],
            );
          }),
    );
  }
}

class PreviousOrderDetails extends StatefulWidget {
  final int orderNo;
  final int total;
  final String address;
  final String name;
  final String number;
  final String date;
  final List item;
  final List quantity;
  final String mobileNumber;
  final List price;
  PreviousOrderDetails(
      {this.orderNo,
      this.total,
      this.address,
      this.name,
      this.number,
      this.date,
      this.item,
      this.quantity,
      this.mobileNumber,
      this.price});
  @override
  _PreviousOrderDetailsState createState() => _PreviousOrderDetailsState();
}

class _PreviousOrderDetailsState extends State<PreviousOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text('Details'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 0),
          decoration: BoxDecoration(color: Colors.grey[300]),
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey)),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "#${widget.orderNo}",
                              style: GoogleFonts.inter(
                                  color: Colors.deepOrange, fontSize: 22),
                            ),
                            Flexible(child: Text('${widget.date}')),
                          ],
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "${widget.name}",
                                  style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Personal No. : ${widget.number}",
                                  style: GoogleFonts.inter(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5),
                                /*Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    "${widget.number}",
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),*/
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Delivered To : ",
                                        style: GoogleFonts.inter(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                            "${widget.address}",
                                            style: GoogleFonts.inter(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      )
                                    ]),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Mobile No. : ${widget.mobileNumber}",
                                  style: GoogleFonts.inter(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5),
                                /*Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    "${widget.mobileNumber}",
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),*/
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        /*Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Menu :',
                              style: GoogleFonts.inter(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            )),*/
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text('Item',
                                    style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline)),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Text('Qty',
                                    style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline)),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Text('Rate',
                                    style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline)),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: OrderData(
                              item: widget.item,
                              quantity: widget.quantity,
                              price: widget.price),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Cost : ₹" + "${widget.total} ",
                                style: GoogleFonts.inter(
                                    color: Colors.black, fontSize: 22),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PreviousOrderDetails()));
                                },
                                child: Container(
                                    /*child: Text('Know More',
                                      style: GoogleFonts.inter(
                                          color: Colors.deepOrange,
                                          decoration:
                                              TextDecoration.underline)),*/
                                    ),
                              )
                            ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
