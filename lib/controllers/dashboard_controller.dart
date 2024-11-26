
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:previewtech/services/database_service.dart';
import '../models/model_custom.dart';
import '../utils/consts.dart';
import '../utils/utility.dart';

class DashboardController extends GetxController {
  var itemList = <ModelPrice>[].obs;
  final List<TextEditingController> itemControllerList = List.empty(growable: true);
  TextEditingController remarkController = TextEditingController();

  setUpItemList(ModelHistory? prevData){
    itemList.addAll([
      ModelPrice(price: 2000, qty: 0, amount: 0),
      ModelPrice(price: 500, qty: 0, amount: 0),
      ModelPrice(price: 200, qty: 0, amount: 0),
      ModelPrice(price: 100, qty: 0, amount: 0),
      ModelPrice(price: 50, qty: 0, amount: 0),
      ModelPrice(price: 5, qty: 0, amount: 0),
      ModelPrice(price: 2, qty: 0, amount: 0),
      ModelPrice(price: 1, qty: 0, amount: 0),
    ]);

    for(int i=0; i<itemList.length; i++){
      final controller = TextEditingController();
      controller.addListener(() {
        updateQty(dataItem: itemList[i], qty: controller.text);
      });
      itemControllerList.add(controller);

      if(prevData!=null){
        if(remarkController.text.isEmpty){
          remarkController.text = prevData.remark;
          saveType = prevData.type;
        }
        for(int j=0; j<prevData.itemList.length; j++){
          if(prevData.itemList[j].price==itemList[i].price){
            itemList[i].qty = prevData.itemList[j].qty;
            controller.text = prevData.itemList[j].qty.toString();
          }
        }
      }
    }
  }
  resetAllItems(){
    for(int i=0; i<itemList.length; i++){
      itemControllerList[i].text = '';
    }
  }

  var finalAmount = (0.0).obs;
  getFinalAmount()=> finalAmount.value;

  updateQty({required ModelPrice dataItem, required qty}){
    dataItem.qty = 0;
    if(qty.isNotEmpty){
      dataItem.qty = int.parse(qty);
    }

    dataItem.amount = dataItem.price * dataItem.qty;
    itemList.refresh();
    finalAmount.value = 0.0;
    for(int i=0; i<itemList.length; i++){
      finalAmount.value = finalAmount.value + itemList[i].amount;
    }
    finalAmount.refresh();
  }


  var buttonVisible = false.obs;
  updateButtonVisible() => buttonVisible.value = !buttonVisible.value;
  isButtonVisible()=> buttonVisible.value;

  final DatabaseService _dbService = DatabaseService();

  insertRecord(BuildContext context) async{
    if(finalAmount.value == 0){
      showMessage(context, 'Enter At Least 1 Item Qty');
      return;
    }
    if(remarkController.text.isEmpty){
      showMessage(context, 'Enter Remark');
      return;
    }

    List<ModelPrice> finalList = List.empty(growable: true);

    for(int i=0; i<itemList.length; i++){
      if(itemList[i].qty > 0){
        finalList.add(itemList[i]);
      }
    }

    await _dbService.insertData(itemList: finalList, remark: remarkController.text, date: getCurrentDate(), time: getCurrentTime(), type: saveType, finalAmount: finalAmount.value.toString());
    showMessage(context, 'Record Inserted');
    resetAllItems();
  }

  updateRecord({required BuildContext context, required ModelHistory dataItem}) async{
    if(finalAmount.value == 0){
      showMessage(context, 'Enter At Least 1 Item Qty');
      return;
    }
    if(remarkController.text.isEmpty){
      showMessage(context, 'Enter Remark');
      return;
    }

    List<ModelPrice> finalList = List.empty(growable: true);

    for(int i=0; i<itemList.length; i++){
      if(itemList[i].qty > 0){
        finalList.add(itemList[i]);
      }
    }

    await _dbService.updateData(id: dataItem.id, itemList: finalList, remark: remarkController.text, finalAmount: finalAmount.value.toString(), type: saveType, date: getCurrentDate(), time: getCurrentTime());
    showMessage(context, 'Record Updated');
    resetAllItems();
  }

  List<String> saveTypeList = [textGeneral, textIncome, textExpense];
  var saveType = textGeneral;
  setSaveType(String value)=> saveType = value;


}
