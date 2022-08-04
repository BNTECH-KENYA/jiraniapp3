import 'package:flutter/material.dart';

class MakeDashboardItems extends StatefulWidget {
  const MakeDashboardItems({Key? key}) : super(key: key);

  @override
  _MakeDashboardItemsState createState() => _MakeDashboardItemsState();
}
class _MakeDashboardItemsState extends State<MakeDashboardItems> {
  Card makeDashboardItem(String title, String img, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(3.0, -1.0),
            colors: [
              Colors.blue,
              Colors.white,
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 3,
              offset: Offset(2, 2),
            )
          ],
        )
            : BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(3.0, -1.0),
            colors: [
              Colors.blue,
              Colors.black,
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 3,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              //1.item
            }
            if (index == 1) {
              //2.item
            }
            if (index == 2) {
              //3.item
            }
            if (index == 3) {
              //4.item
            }
            if (index == 4) {
              //5.item
            }
            if (index == 5) {
              //6.item
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  img,
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.home_filled, color: Colors.white,),
        title: Text("Home", style: TextStyle(
          color: Colors.white
        ),),

      ),

      body: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(2),
              children: [
                makeDashboardItem("Groups", "assets/catering.jfif", 0),
                makeDashboardItem("My Services", "assets/catering.jfif", 1),
                makeDashboardItem("Services", "assets/catering.jfif", 2),
                makeDashboardItem("My Store", "assets/catering.jfif", 3),
                makeDashboardItem("Stores", "assets/catering.jfif", 4),
                makeDashboardItem("Settings", "assets/catering.jfif", 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}