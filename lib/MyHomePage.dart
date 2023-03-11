import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jokes/model/joke.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CollectionReference _jokes =
      FirebaseFirestore.instance.collection('jokes');

  late PageController _pageController;
  int _jokeNumber = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50,
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/joke.jpg'),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          "Handicrafted by",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        Text(
                          "Gia Huy",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('assets/images/avatar.jpg'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "A joke a day keeps the doctor away",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "If you joke wrong way, your teeth have to pay. (Serious)",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 7,
              child: Container(
                  child: Column(
                children: [
                  Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 40),
                        child: StreamBuilder(
                            stream: _jokes.snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              } else if (snapshot.hasData) {
                                return PageView.builder(
                                  controller: _pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    final DocumentSnapshot docJoke =
                                        snapshot.data!.docs[index];
                                    return buildJoke(docJoke, snapshot);
                                  },
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                      )),
                ],
              ))),
          Divider(
            color: Colors.grey,
          ),
          Expanded(
              flex: 2,
              child: Container(
                  child: Text(
                "This appis created by Tran Gia Huy as a test to apply for an Internship program in ZenS company,"
                " Reference UI to Hlsolutions via github",
                textAlign: TextAlign.center,
              ))),
        ],
      ),
    );
  }

  Column buildJoke(DocumentSnapshot<Object?> docJoke,
      AsyncSnapshot<QuerySnapshot> snapshot) {
    final Joke temp = new Joke(
        text: docJoke['text'],
        id: docJoke['id'],
        isLocked: docJoke['isLocked'],
        isFun: docJoke['isFun']);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 8,
          child: Text(
            _jokeNumber <= snapshot.data!.docs.length ? temp.text
            : "That's all the jokes for today! Come back another day!",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder()),
                    onPressed: () {
                      final doc = FirebaseFirestore.instance
                          .collection('jokes')
                          .doc(docJoke.id);

                      doc.update({'isFun': true, 'isLocked' : true});

                      if (_jokeNumber < snapshot.data!.docs.length) {
                        _pageController.nextPage(
                            duration: const Duration(microseconds: 250),
                            curve: Curves.easeInExpo);
                      }
                      setState(() {
                        _jokeNumber++;
                      });
                    },
                    child: Text("This is Funny!"),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(// <-- Radius
                              ),
                          backgroundColor: Colors.green),
                      onPressed: () {
                        final doc = FirebaseFirestore.instance
                            .collection('jokes')
                            .doc(docJoke.id);
                        doc.update({'isFun': false, 'isLocked' : true});

                        if (_jokeNumber <= snapshot.data!.docs.length) {
                          _pageController.nextPage(
                              duration: const Duration(microseconds: 250),
                              curve: Curves.easeInExpo);
                        }

                        setState(() {
                          _jokeNumber++;
                        });
                      },
                      child: Text("This is not funny")),
                ),
                SizedBox()
              ],
            ),
          ),
        )
      ],
    );
  }
}
