import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:previewtech/models/model_custom.dart';
import 'package:previewtech/utils/utility.dart';
import '../controllers/dashboard_controller.dart';
import '../utils/consts.dart';
import '../utils/routes.dart';
import 'common/button_primary.dart';
import 'common/input_primary.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  ModelHistory? prevData;

  Dashboard({this.prevData});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DashboardController controller = DashboardController();


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result){
        onBackPressed();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
                pinned: true,
                floating: true,
                expandedHeight: 150.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => (controller.getFinalAmount()>0)?Expanded(child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 3.0,),
                            Text('Total Amount',
                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w600),),
                            const SizedBox(height: 3.0,),
                            Text('$symbolRupee ${controller.getFinalAmount()}',
                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w600),),
                            const SizedBox(height: 3.0,),
                            Row(children: [
                              Text(getConvertedText(controller.getFinalAmount()),
                                style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12.0),)
                            ],),
                          ],
                        )):Text(appName,
                          style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w600))),
                        PopupMenuButton(
                          iconColor: Colors.white,
                          initialValue: 0,
                          itemBuilder: (context) => [
                            PopupMenuItem<int>(
                              onTap: (){ proceedHistory(); },
                              value: 0,
                              child: Text("History"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  background: Image.asset('assets/images/currency_banner.jpg', fit: BoxFit.cover,),
                ),
              ),
            ];
          },
          body: bodyWidget(),
        ),
        floatingActionButton: CustomFloatingButton(controller: controller, prevData: widget.prevData),
      ),
    );
  }

  Widget bodyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Obx(()=> ListView.builder(
              itemCount: controller.itemList.length,
              itemBuilder: (context, index){
                ModelPrice dataItem = controller.itemList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(children: [
                    Expanded(child: Text('$symbolRupee ${dataItem.price} X', style: GoogleFonts.montserrat(color: Colors.white, fontSize: 20.0),)),
                    const SizedBox(width: 10.0,),
                    Expanded(child: InputPrimary(
                      suffixText: '',
                      hintText: 'Enter Qty',
                      labelText: 'Qty',
                      controller: controller.itemControllerList[index],
                      inputType: TextInputType.number,
                      maxLength: 3,
                      clearAction: (){
                        controller.itemControllerList[index].text = '';
                      },
                    )),
                    const SizedBox(width: 10.0,),
                    Expanded(child: Text('= $symbolRupee ${dataItem.amount}', style: GoogleFonts.montserrat(color: Colors.white, fontSize: 20.0))),
                  ],),
                );
              })))
        ],
      ),
    );
  }

  @override
  initState() {
    super.initState();
    controller.setUpItemList(widget.prevData);
  }

  proceedHistory(){
    Navigator.pushNamed(context, Routes.history);
  }

  Future<bool> onBackPressed() async {
    if (widget.prevData!=null) {
      Navigator.pop(context); // closes the drawer if opened
      return Future.value(false); // won't exit the app
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text("Confirm Exit"),
                content: const Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  TextButton(
                      child: const Text("YES"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        SystemNavigator.pop();
                      }),
                  TextButton(
                      child: const Text("NO"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]);
          });
      return Future.value(false);
    }
  }

}

class CustomFloatingButton extends StatelessWidget {
  DashboardController controller;
  ModelHistory? prevData;

  CustomFloatingButton({super.key,
    required this.controller, this.prevData});

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (controller.isButtonVisible()) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 140.0),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
              heroTag: 'saveButton',
              onPressed: () {
                controller.updateButtonVisible();
                openSaveDialog(context);
              },
              backgroundColor: Colors.grey.shade700,
              child: const Icon(Icons.save_alt, color: Colors.white,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 75.0),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
              heroTag: 'clearButton',
              onPressed: () {
                controller.updateButtonVisible();
                controller.resetAllItems();
              },
              backgroundColor: Colors.grey.shade700,
              child: const Icon(Icons.restart_alt, color: Colors.white,),
            ),
          ),
        ],
        FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          heroTag: 'mainButton',
          onPressed: (){
            controller.updateButtonVisible();
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(controller.isButtonVisible() ? Icons.close : Icons.electric_bolt, color: Colors.white,),
        ),
      ],
    ));
  }

  openSaveDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),),
                      InkWell(onTap: (){
                        Navigator.pop(context);
                        }, child: const Icon(Icons.clear),)
                    ],
                  ),
                  const SizedBox(height: 15.0,),
                  DropdownButtonFormField2<String>(
                    value: textGeneral,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    hint: const Text(
                      'Select Registeration Type',
                      style: TextStyle(fontSize: 14),
                    ),
                    items: controller.saveTypeList
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                        .toList(),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: (value) {
                      if(value!=null){
                        controller.setSaveType(value);
                      }
                    },
                  ),
                  const SizedBox(height: 15.0,),
                  TextFormField(
                    controller: controller.remarkController,
                    keyboardType: TextInputType.multiline,
                    enabled: true,
                    maxLines: 6,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 0.6),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 10.0),
                      focusedBorder: const OutlineInputBorder(),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: 'Enter Remark...',
                      hintStyle: TextStyle(fontSize: 14, color: const Color(0xff3A3A3A).withOpacity(0.6)),
                      label: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Remarks', style: TextStyle(color: Colors.black, fontSize: 12)),
                            TextSpan(
                                text: '',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      labelStyle: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 25,),
                  ButtonPrimary(text: 'Save', buttonAction: (){
                    if(prevData!=null){
                      controller.updateRecord(context: context, dataItem: prevData!);
                      Navigator.pop(context);
                    }
                    else{
                      controller.insertRecord(context);
                      Navigator.pop(context);
                    }

                  },)
                ],
              ),
            ),
          );
        });
  }
}

