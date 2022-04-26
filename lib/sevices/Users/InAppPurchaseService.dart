import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gladbettor/model/User.dart';
import 'package:gladbettor/sevices/FirebaseServiceDefault.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool kAutoConsume = true;
String _kConsumableId = '';
String _kSubscriptionId = '';
List<String> _kAndroidProductIds = <String>[''];
List<String> _kiOSProductIds = <String>[''];

class InAppPurchaseService {
  final String uid;

  InAppPurchaseService(this.uid);

  StreamController<int> showMessageStreamController = StreamController<int>();

  static const String testID = 'consumable';
  List<String> _kProductIds = <String>[
    'upgrade',
    'subscription',
    "credit_10",
    "credit_30",
    "credit_100",
  ];

  BuildContext context;
  String purchaseId;

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _connectionSubscription;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;

  Future<void> initStoreInfo(String userId) async {
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      print("connection is available :- ${!isAvailable}");
      _isAvailable = isAvailable;
      _products = [];
      _purchases = [];
      _notFoundIds = [];
      _purchasePending = false;
      _loading = false;
      return;
    }
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      print("streming data $_subscription");
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());

    print(
        "productDetailResponse: ${productDetailResponse.productDetails.length}");
    if (productDetailResponse.error != null) {
      print("productDetailResponse error...");
      _queryProductError = productDetailResponse.error.message;
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
      print("productDetailResponse error: ${_queryProductError.toString()}");

      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      print("productDetailResponse Details is empty");
      _queryProductError = null;
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {

      print("During purchase error");
    }
    _isAvailable = isAvailable;
    _products = productDetailResponse.productDetails;
    _notFoundIds = productDetailResponse.notFoundIDs;
    _purchasePending = false;
    _loading = false;
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }

  Future<void> subscription(String purchaseId, BuildContext context) async {
    print("subscription function purchaseId--> $purchaseId");
    this.context = context;
    print("_products length-->${_products.length}");
    ProductDetails productDetails = _products.firstWhere((element) {
      print("productDetails id := ${element.id}");
      print("productDetails description := ${element.description}");
      return element.id == purchaseId;
    }, orElse: () {
      print(" null");
      return null;
    });
    if (productDetails != null) {
      print("Produc Price =${productDetails.price}");
      print("App ProducId =${purchaseId.toString()}");
      print("Item ProducId =${productDetails.id}");
      this.purchaseId = purchaseId;
      try {
        print("subscription try part......................");
        PurchaseParam purchaseParam = PurchaseParam(
            productDetails: productDetails,
            applicationUserName: null,
            sandboxTesting: false);
        print("purchaseParam ------------------->$purchaseParam");
        _connection.buyConsumable(
            purchaseParam: purchaseParam,
            autoConsume: Platform.isAndroid || Platform.isIOS);
        // Constants.onOneTap=1;
      } catch (error) {
        print("subscription error part......................$error");
      }
    }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    print('_handleInvalidPurchase');
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("helllllllo***************");

        // FirebaseAnalyticsUtils().sendAnalyticsEvent(
        //     FirebaseAnalyticsUtils.PurchaseStatusPanding);
      }
      else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // showInSnackBar(purchaseDetails.error.message);
        }
        else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            FirebaseAnalyticsUtils().sendAnalyticsEvent(
                FirebaseAnalyticsUtils.paymentCancle+"With"+purchaseDetails.purchaseID);
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          // FirebaseAnalyticsUtils().sendAnalyticsEvent(
          //     FirebaseAnalyticsUtils.pandingcompletePirchase);
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
      Constants.onOneTap=1;
      print("helllllllo");
    });
  }

  void dispose() {
    Constants.onOneTap=1;
    print("dispose_");
    if (_connectionSubscription != null) {
      _connectionSubscription.cancel();
      _connectionSubscription = null;
    }
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {

    if (purchaseDetails.productID == purchaseId) {
      showMessageStreamController.add(1);
      await ConsumableStore.save(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.load();
      // print("list of product purchase ====> $consumables");
      _purchases.add(purchaseDetails);
      // for (PurchaseDetails purchase in _purchases) {
      // //   if (await _verifyPurchase(purchase)) {
      // //     // print("purchase transactionDate --->${purchase.transactionDate}");
      // //     // print("purchase productID --->${purchase.productID}");
      // //     // print("purchase purchaseID --->${purchase.purchaseID}");
      // //     // print("purchase transactionDate --->${purchase.verificationData}");
      // //     // print("purchase error --->${purchase.error}");
      // //   }
      // //   FirebaseServiceDefault.purchaseDetail(
      // //     userId: uid,
      // //     purchaseId: purchase.productID,
      // //     orderDate: purchase.transactionDate,
      // //     orderNumber: purchase.purchaseID,
      // //   );
      //
      // }
      if (purchaseDetails.productID == "credit_10") {
        purchase( purchaseDetails.productID,purchaseDetails.transactionDate,purchaseDetails.purchaseID,10);
      } else if (purchaseDetails.productID == "credit_30") {
        purchase( purchaseDetails.productID,purchaseDetails.transactionDate,purchaseDetails.purchaseID,30);
      } else if (purchaseDetails.productID == "credit_100") {
        purchase( purchaseDetails.productID,purchaseDetails.transactionDate,purchaseDetails.purchaseID,100);
      }
      Constants.onOneTap=1;
      _purchasePending = false;
    } else {
      Constants.onOneTap=1;
      FirebaseAnalyticsUtils().sendAnalyticsEvent(
          FirebaseAnalyticsUtils.paymentfail +"with"+purchaseDetails.purchaseID);
      showMessageStreamController.add(0);
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    }
  }

  purchase(pid,transactionDate,purchasid,extraCreditAdd)async{
    FirebaseServiceDefault.purchaseDetail(
      userId: uid,
      purchaseId:pid,
      orderDate: transactionDate,
      orderNumber:purchasid ,
    );
    FirebaseAnalyticsUtils().sendAnalyticsEvent(
        FirebaseAnalyticsUtils.paymentsuccessfully +"with"+purchasid);
    User user = await FirebaseServiceDefault.getUser(uid);
    print("buy credits ${extraCreditAdd} + User firebase credits ${user.credit} ");
    Constants.credit =extraCreditAdd + user.credit;
    print("total credits---->${Constants.credit}");
    await FirebaseServiceDefault.decreaseCredit(uid, Constants.credit);
  }

}

class ConsumableStore {
  static const String _kPrefKey = 'consumables';
  static Future<void> _writes = Future.value();

  static Future<void> save(String id) {
    _writes = _writes.then((void _) => _doSave(id));
    return _writes;
  }

  static Future<void> consume(String id) {
    _writes = _writes.then((void _) => _doConsume(id));
    return _writes;
  }

  static Future<List<String>> load() async {
    return (await SharedPreferences.getInstance()).getStringList(_kPrefKey) ??
        [];
  }

  static Future<void> _doSave(String id) async {
    List<String> cached = await load();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKey, cached);
  }

  static Future<void> _doConsume(String id) async {
    List<String> cached = await load();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKey, cached);
  }
}

// void showInSnackBar(String value) {
//   final snackBar = SnackBar(
//     content: Text(value),
//   );
//   Scaffold.of(context).showSnackBar(snackBar);
// }