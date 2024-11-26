
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:previewtech/models/model_custom.dart';
import 'package:previewtech/services/database_service.dart';
import 'package:previewtech/utils/consts.dart';
import 'package:previewtech/utils/enums.dart';
import 'package:share_plus/share_plus.dart';


class HistoryController extends GetxController {
  var itemList = <ModelHistory>[].obs;
  final DatabaseService _dbService = DatabaseService();
  getHistory() async{
    pageState.value = PageState.init;
    var data = await _dbService.fetchData();
    if(data==null){
      pageState.value = PageState.empty;
    }
    else{
      itemList.value = data;
      pageState.value = PageState.loaded;
    }
  }


  var pageState = PageState.init.obs;
  isPageLoaded() => pageState.value == PageState.loaded;
  isPageLoading() => pageState.value == PageState.init;
  isPageEmpty() => pageState.value == PageState.empty;
  isPageError() => pageState.value == PageState.error;


  shareItem(ModelHistory dataItem){

    int totalCounts = 0;
    List<String> calculations = dataItem.itemList.map((item) {
      totalCounts = totalCounts + item.qty;
      return "$symbolRupee ${item.price} x ${item.qty} = $symbolRupee ${item.price * item.qty}";
    }).toList();
    String listCalculations = calculations.join('\n');


    String sharedString = "${dataItem.type}\n$appName\n${dataItem.date} ${dataItem.time}\n${dataItem.remark}\n"
        "-------------------------------------\n"
        "Rupee x Counts = Total\n$listCalculations\n"
        "-------------------------------\n"
        "Total Counts: $totalCounts\n"
        "Grand Total Amount:\n"
        "$symbolRupee ${dataItem.finalAmount}";

    Share.share(sharedString);


  }

  removeItem(ModelHistory dataItem){
    itemList.remove(dataItem);
    _dbService.deleteData(dataItem.id);
  }



}
