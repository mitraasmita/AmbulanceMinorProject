import 'package:driver_app/pages/earnings_page.dart';
import 'package:driver_app/pages/home_page.dart';
import 'package:driver_app/pages/profile_page.dart';
import 'package:driver_app/pages/trips_page.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget
{
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin
{
  TabController? controller;
  int indexSelected =0;//We have 4 pages, each index no. will guide us to each page selected by the driver.


  onBarItemClicked(int i)//This parameter is the page that the driver clicked
  {
    setState(() {
      indexSelected = i;//Assign the index clicked to the index selected.
      controller!.index = indexSelected;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          HomePage(),
          EarningsPage(),
          TripsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const
        [
          BottomNavigationBarItem
            (
              icon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem
            (
              icon: Icon(Icons.credit_card),
              label: "Earnings"
          ),
          BottomNavigationBarItem
            (
              icon: Icon(Icons.account_tree),
              label: "Trips"
          ),
          BottomNavigationBarItem
            (
              icon: Icon(Icons.person),
              label: "Profile"
          ),
        ],
        currentIndex: indexSelected,
        //backgroundColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.purple,
        showSelectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: onBarItemClicked,
      ),
    );
  }
}
