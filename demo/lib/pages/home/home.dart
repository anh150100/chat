import 'package:demo/controller/auth.dart';
import 'package:demo/controller/botom_nav.dart';
import 'package:demo/controller/google_controller.dart';
import 'package:demo/pages/home/widget/header.dart';
import 'package:demo/pages/home/widget/list_user.dart';
import 'package:demo/pages/home/widget/search.dart';
import 'package:demo/pages/home/widget/user_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
    @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthController>(context);
    final loginGoogle = Provider.of<GoogleController>(context);
    final TextEditingController _searchController = TextEditingController();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex:context.watch<BottomNavController>().count,

        onTap: (index) {
          context.read<BottomNavController>().increment(index);
          _pageController.jumpToPage(index);
          // context.read<BottomNavigationController>().onTap(index);
        },
        unselectedItemColor: Colors.black26,
        selectedItemColor:Colors.lightBlueAccent,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: "Danh sách",
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Column(
                  children:[
                    const Header(),
                    const SizedBox(height: 10,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 136,
                      child:  ListView(
                        shrinkWrap: true,
                        children: [
                          Search(searchController: _searchController),
                          const SizedBox(height: 10,),
                          const ListUser(),
                          const SizedBox(height: 10,),
                          const UserItem(),
                        ],
                      ),
                    )
                  ]
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: IconButton(
                onPressed: ()async {
                  await loginProvider.logout();
                  await loginGoogle.ggLogout();
                },
                icon: const Text("Log out")
            ),
          )
        ],
      )

    );
  }
}


