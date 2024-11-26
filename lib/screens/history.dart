
import 'package:flutter/material.dart';
import 'package:previewtech/controllers/history_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:previewtech/models/model_custom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:previewtech/utils/consts.dart';
import '../utils/ccolor.dart';
import '../utils/routes.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  HistoryController controller = HistoryController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: InkWell(onTap: (){Navigator.pop(context);}, child: const Icon(Icons.arrow_back, color: Colors.white,),),
        title: Text('History', style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),),
      ),
      body: bodyWidget(),
    );
  }

  bodyWidget(){
    return Obx(() {
      if(controller.isPageLoaded()){
        return Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0), child: ListView.builder(
            itemCount: controller.itemList.length,
            itemBuilder: (contex, index){
              ModelHistory dataItem = controller.itemList[index];
              return Slidable(
                  startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            controller.removeItem(dataItem);
                          },
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                        ),
                        SlidableAction(
                          onPressed: (_) { proceedToUpdate(dataItem); },
                          backgroundColor: const Color(0xFF0392CF),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                        ),
                        SlidableAction(
                          onPressed: (_) {
                            controller.shareItem(dataItem);
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.share,
                        ),
                      ]),
                  child: Card(
                    color: primaryTeal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(controller.itemList[index].type, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14.0,
                                  fontWeight: FontWeight.w500),))
                            ],
                          ),
                          const SizedBox(height: 3.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$symbolRupee ${controller.itemList[index].finalAmount}', style: GoogleFonts.montserrat(color: Colors.blue, fontSize: 22.0,
                                  fontWeight: FontWeight.w500)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(controller.itemList[index].date, style: GoogleFonts.montserrat(color: Colors.grey.shade500, fontSize: 10.0),),
                                  const SizedBox(height: 3.0,),
                                  Text(controller.itemList[index].time, style: GoogleFonts.montserrat(color: Colors.grey.shade500, fontSize: 10.0),)
                                ],
                              )

                            ],
                          ),
                          const SizedBox(height: 3.0,),
                          Row(
                            children: [
                              Expanded(child: Text(controller.itemList[index].remark, style: GoogleFonts.montserrat(color: colorBlueLight, fontSize: 10.0)))
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
            }),);
      }
      else if(controller.isPageEmpty()){
        return const Center(child: Text('No Record Found'));
      }
      else{
        return const Center(child: CircularProgressIndicator(),);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.getHistory();
  }

  proceedToUpdate(ModelHistory dataItem){
    Navigator.pushNamed(context, Routes.dashboard, arguments: {'item': dataItem}).then((value)=> controller.getHistory());
  }

}
