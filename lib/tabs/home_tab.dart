import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeTab extends StatelessWidget {

  Future<QuerySnapshot> docsData() async {
    await Firebase.initializeApp();
    QuerySnapshot data = await FirebaseFirestore.instance.collection('home').orderBy("pos").get();
    print(data);
    return data;
  }

  Stream? slides;
  List dados = [];

  List data = [
    'https://images.unsplash.com/photo-1571104508999-893933ded431?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1571104508999-893933ded431?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1571104508999-893933ded431?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1571104508999-893933ded431?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80'
  ];

  CollectionReference datas = FirebaseFirestore.instance.collection('home');

  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // ignore:
          colors: [
            Color.fromARGB(255, 20, 0, 10),
            Color.fromARGB(255, 0, 0, 8)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          _buildBodyBack(),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.search, size: 27,
                    ),
                  )
                ],
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 80),
              Expanded(
                  flex: 1,
                  child: Center(
                        child: Image.network('https://img.freepik.com/premium-vector/vintage-luxury-royal-frame-labels-with-logo-beer-whiskey-alcohol-drinks-bottle-packaging-desig_117739-2804.jpg'),

                  )
              ),
              SizedBox(height: 60),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('home').snapshots().map((event) => event),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<DocumentSnapshot> docuemnts = snapshot.data!.docs.toList();
                      docuemnts.forEach((element) {dados.add(element.data());});
                      return Row(
                          children: [
                            Expanded(
                              flex: 1,
                                child: Container(
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        viewportFraction: 0.8,
                                        autoPlayAnimationDuration: const Duration(seconds: 2),
                                        autoPlay: true,
                                        enlargeCenterPage: true
                                    ),
                                    items: dados.map((e) => Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          e['image'],
                                          height: 370,

                                          width: 380,
                                        ),
                                      )
                                    )).toList(),
                                  ),
                                ),
                            ),
                            Container(),
                          ],
                        );
                    }
                  }
              ),
              SizedBox(height: 100,),
            ],
          )
        ],
      ),
    );
  }

    List<Widget> _queryDb() {
      slides = FirebaseFirestore.instance.collection('home').snapshots().map((
          event) => event.docs.map((doc) => doc.data()));
      print(slides);
      return data.map((e) =>
          Center(
            child: Image.network(
              e,
              height: 470,
            ),
          )).toList();

  }
}