library country_state_city_picker_nona;

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'model/select_status_model.dart' as StatusModel;
// import 'package:couple_match/countryModel/assets/country.json';
// import 'model/select_status_model.dart';

class SelectStateData extends StatefulWidget {
  final TextStyle? style;
  final Color? dropdownColor;
  final InputDecoration decoration;
  final double spacing;

  const SelectStateData({
    Key? key,
    this.decoration =
        const InputDecoration(contentPadding: EdgeInsets.all(0.0)),
    this.spacing = 0.0,
    this.style,
    this.dropdownColor,
    // this.onCountryTap,
    // this.onStateTap,
    // this.onCityTap
  }) : super(key: key);

  @override
  _SelectStateDataState createState() => _SelectStateDataState();
}

class _SelectStateDataState extends State<SelectStateData> {
  List<StatusModel.City> _cities = [];
  List<StatusModel.City> loadCities = [];
  // List<StatusModel.State> _country = [];
  String _selectedCity = "Choose City";
  String _selectedCountry = "Choose Country";
  String _selectedState = "Choose State/Province";
  List<StatusModel.State> _states = [];
  var responses;

  @override
  void initState() {
    getState();
    getCity();
    super.initState();
  }

  Future getResponse() async {
    var res = await rootBundle.loadString('assets/files/states.json');
    return jsonDecode(res);
  }

  // Future getStates() async {
  //   var states = await getResponse() as List;
  //   print("getcountry running");
  //   for (var data in states) {
  //
  //     var model = StatusModel.State.fromJson(data);
  //     Logger().wtf("Get Data", model);
  //     // model.name = data['name'];
  //     if (!mounted) continue;
  //     setState(() {
  //       _states.add(model);
  //     });
  //
  //     //get state
  //
  //
  //   }
  //
  //   return _states;
  // }

  List<StatusModel.StatusModel> selectedCountryList = [];
  List<StatusModel.State> selectedStateList = [];
  List<StatusModel.City> selectedCityList = [];

  List<List<String>> selectedLocation = [[], [], []];

  Future getState() async {
    // var response = await getResponse();
    var states = await getResponse() as List;
    //   print("getcountry running");
    //   for (var data in states) {
    //
    //     var model = StatusModel.State.fromJson(data);
    //     Logger().wtf("Get Data", model);
    //     // model.name = data['name'];
    //     if (!mounted) continue;
    //     setState(() {
    //       _states.add(model);
    //     });
    //
    //     //get state
    //
    //
    //   }
    //
    //   return _states;
    // var states = takestate as List;
    for (var f in states) {
      if (!mounted) continue;
      setState(() {
        // var name = f.map((item) => item).toList();
        // for (var statename in name) {
          // print(statename.toString());

          _states.add(StatusModel.State.fromJson(f));
          // setState(() {});
        // }
      });
    }

    return _states;
  }

  Future getCity() async {
    var res = await rootBundle.loadString('assets/files/cities.json');
    final getCitiesList = jsonDecode(res) as List;
    final List<StatusModel.City> cities = getCitiesList.map((e)=> StatusModel.City.fromJson(e)).toList();
    if(selectedStateList.isEmpty){
      for (StatusModel.City city in cities) {
        if (!mounted) continue;
        setState(() {
          _cities.add(city);
        });
      }
      // setState(() {
      //   _cities.addAll(cities);
      // });
      return _cities;
    }
    else{
      for(StatusModel.State selectedState in selectedStateList){
        final List<StatusModel.City> filteredCities = cities.where((element) => element.state == selectedState.id).toList();
        setState(() {
          _cities.addAll(filteredCities);
        });
      }
      return _cities;
    }
  }

  bool countryfocus = false;
  bool statefocus = false;
  bool cityfocus = false;

  // TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final state = TextEditingController();
  final city = TextEditingController();
  // List<StatusModel.StatusModel> countryDataList = [];
  List<StatusModel.State>? stateDataList = [];
  List<StatusModel.City> cityDataList = [];

  // countryData(List<StatusModel.StatusModel> data, String val) {
  //   print("uuuuuuuuuuu$data");
  //   if (selectedCountryList.isNotEmpty) {
  //     val = val.split(',').last;
  //   }
  //
  //   List<StatusModel.StatusModel> tempCount = _country
  //       .where((element) =>
  //           element.name!.toLowerCase().startsWith(val.toLowerCase()))
  //       .toList();
  //   print(tempCount);
  //   setState(() {
  //     countryDataList = tempCount;
  //   });
  // }

  // List<String> stateDataList = [];

  stateData(List<StatusModel.State> dataList, String val) {
    print("ssssssssss$dataList");
    if (selectedStateList.isNotEmpty) {
      val = val.split(',').last;
    }

    // List<List<StatusModel.State>?> tempCount =

    // List<StatusModel.State>? temp = [];
    // for (List<StatusModel.State>? data
    // in dataList.map((e) => e.state).toList()) {
    List<StatusModel.State> temp = _states
        .where((element) =>
            element.name!.toLowerCase().startsWith(val.toLowerCase()))
        .toList();

    setState(() {
      stateDataList = temp;
    });
  }

  cityData(List<StatusModel.City> data, String val) {
    print("uuuuuuuuuuu$data");
    if (selectedCityList.isNotEmpty) {
      val = val.split(',').last;
    }

    List<StatusModel.City> tempCount = data
        .where((element) =>
            element.name!.toLowerCase().startsWith(val.toLowerCase()))
        .toList();
    print(tempCount);
    setState(() {
      cityDataList = tempCount;
    });
  }

// 🇦🇫    Afghanistan
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
            onTap: () {
              for (var element in selectedCityList) {
                selectedLocation[0].add(element.name.toString());
              }
              for (var element in selectedStateList) {
                selectedLocation[1].add(element.name.toString());
              }
              // for (var element in selectedCountryList) {
              //   selectedLocation[2].add(element.name.toString());
              // }
              // selectedLocation = [selectedCountryList, selectedStateList];
              Navigator.of(context).pop(selectedLocation);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.lightBlueAccent,
              size: 25,
            ),
          ),
          middle: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ImageIcon(
                //   AssetImage('images/icons/location_home.png'),
                //   size: 25,
                //   color: Colors.lightBlueAccent,
                // ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  // margin: EdgeInsets.only(right: 12),
                  child: DefaultTextStyle(
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Sans-serif',
                          fontWeight: FontWeight.w700,
                          fontSize: 24),
                      child: Text("Address")),
                )
              ],
            ),
          ),
          previousPageTitle: "",
        ),
        child: Container(
            margin: EdgeInsets.only(top: 100),
            padding: EdgeInsets.symmetric(horizontal: 20),
            // height: MediaQuery.of(context).size.height * 9.0,
            child: Column(
              children: [
                Material(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // SizedBox(height: 50),
                        // Focus(
                        //   onFocusChange: (val) {
                        //     countryfocus = val;
                        //     setState(() {});
                        //   },
                        //   child: SingleChildScrollView(
                        //     child: Container(
                        //       margin: EdgeInsets.symmetric(horizontal: 10),
                        //       decoration: containerStyle,
                        //       height: 50,
                        //       child: ListView(
                        //         scrollDirection: Axis.horizontal,
                        //
                        //         // reverse: true,
                        //         children: [
                        //           ...List<Widget>.generate(
                        //               selectedCountryList.length,
                        //               (index) => GestureDetector(
                        //                     onTap: () {
                        //                       setState(() {
                        //                         selectedCountryList.removeWhere(
                        //                             (element) =>
                        //                                 selectedCountryList[
                        //                                         index]
                        //                                     .name ==
                        //                                 element.name);
                        //                         removeState();
                        //                       });
                        //                     },
                        //                     child: Container(
                        //                       margin:
                        //                           const EdgeInsets.symmetric(
                        //                               vertical: 10,
                        //                               horizontal: 5),
                        //                       padding:
                        //                           const EdgeInsets.symmetric(
                        //                               horizontal: 5),
                        //                       height: 20,
                        //                       decoration: BoxDecoration(
                        //                           borderRadius:
                        //                               BorderRadius.circular(10),
                        //                           color: const Color.fromARGB(
                        //                               255, 230, 228, 228)),
                        //                       child: Row(
                        //                         children: [
                        //                           Text(
                        //                               selectedCountryList[index]
                        //                                   .name!),
                        //                           Icon(CupertinoIcons
                        //                               .clear_circled , color: Colors.lightBlueAccent,)
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   )),
                        //           // Container(
                        //           //   // decoration: containerStyle,
                        //           //   height: 50,
                        //           //   width: width - 50,
                        //           //   margin: const EdgeInsets.symmetric(
                        //           //       horizontal: 10),
                        //           //   padding: const EdgeInsets.symmetric(
                        //           //       horizontal: 5),
                        //           //   child: TextField(
                        //           //     decoration: textFiedstyle.copyWith(
                        //           //       hintText: 'Country',
                        //           //     ),
                        //           //
                        //           //     // focusNode: countryfocus,
                        //           //     controller: countryController,
                        //           //     onChanged: (value) {
                        //           //       countryData(_country, value);
                        //           //     },
                        //           //   ),
                        //           // ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // countryfoc
                        //us.addListener(() { })
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // countryfocus
                        //     ? Container(
                        //         height:
                        //             MediaQuery.of(context).size.height * 0.29,
                        //         // height: 230,
                        //         child: SingleChildScrollView(
                        //           child: Column(
                        //             children: countrySuggetion(countryDataList),
                        //           ),
                        //         ),
                        //       )
                        //     : Container(),
                        // const SizedBox(height: 20),

                        countryfocus
                            ? Container()
                            : Focus(
                                onFocusChange: (val) {
                                  statefocus = val;
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: containerStyle,
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    // child: ListView(
                                    children: [
                                      ...List<Widget>.generate(
                                          selectedStateList.length,
                                          (index) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedStateList
                                                        .removeWhere((element) =>
                                                            selectedStateList[
                                                                    index]
                                                                .name ==
                                                            element.name);
                                                    // kkk
                                                    removeCity();
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              230,
                                                              228,
                                                              228)),
                                                  child: Row(
                                                    children: [
                                                      Text(selectedStateList[
                                                              index]
                                                          .name!),
                                                      Icon(CupertinoIcons
                                                          .clear_circled , color: Colors.lightBlueAccent,)
                                                    ],
                                                  ),
                                                ),
                                              )),
                                      Container(
                                        height: 50,
                                        width: width - 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextField(
                                          decoration: textFiedstyle.copyWith(
                                              hintText: 'State'),

                                          // focusNode: countryfocus,
                                          controller: stateController,
                                          onChanged: (value) {
                                            stateData(_states, value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                        const SizedBox(
                          height: 10,
                        ),

                        statefocus
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.22,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: stateSuggetion(stateDataList!),
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 20),

                        countryfocus || statefocus
                            ? Container()
                            : Focus(
                                onFocusChange: (val) {
                                  cityfocus = val;
                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: containerStyle,
                                  height: 50,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ...List<Widget>.generate(
                                          selectedCityList.length,
                                          (index) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedCityList.removeWhere(
                                                        (element) =>
                                                            selectedCityList[
                                                                    index]
                                                                .name ==
                                                            element.name);
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              230,
                                                              228,
                                                              228)),
                                                  child: Row(
                                                    children: [
                                                      Text(selectedCityList[
                                                              index]
                                                          .name! ),
                                                      Icon(CupertinoIcons
                                                          .clear_circled, color: Colors.lightBlueAccent,)
                                                    ],
                                                  ),
                                                ),
                                              )),
                                      Container(
                                        height: 50,
                                        width: width - 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextField(
                                          decoration: textFiedstyle.copyWith(
                                              hintText: 'City'),

                                          // focusNode: countryfocus,
                                          controller: cityController,
                                          onChanged: (value) {
                                            cityData(_cities, value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        // countryfocus.addListener(() { })
                        // count
                        // ryfocus
                        const SizedBox(
                          height: 10,
                        ),

                        cityfocus
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: citySuggetion(cityDataList),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: height / 3,
                        ),
                        // OutlinedButton(
                        //   onPressed: () {},
                        //   child: Padding(
                        //     padding:
                        //         EdgeInsets.symmetric(horizontal: width / 3, vertical: 17),
                        //     child: const Text(
                        //       'Contiune',
                        //       style: TextStyle(
                        //                   fontFamily: 'Serif',
                        //                   fontSize: 20,
                        //                   fontWeight: FontWeight.w700,
                        //                   color: Colors.black,
                        //                 ),
                        //     ),
                        //   ),
                        //   style: OutlinedButton.styleFrom(
                        //       shape: const StadiumBorder(), shadowColor: Colors.black),
                        // ),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shadowColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.black),
                                  // padding:
                                  //     MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                  //         EdgeInsets.symmetric(vertical: 17)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                              child: const Text(
                                "Continue",
                                style: TextStyle(
                                  fontFamily: 'Serif',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                for (var element in selectedCityList) {
                                  selectedLocation[0]
                                      .add(element.name.toString());
                                }
                                for (var element in selectedStateList) {
                                  selectedLocation[1]
                                      .add(element.name.toString());
                                }
                                // for (var element in selectedCountryList) {
                                //   selectedLocation[2]
                                //       .add(element.name.toString());
                                // }
                                Navigator.of(context).pop(selectedLocation);
                              },
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 20,
                        // )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  void removeState() {
    _states = [];
    stateDataList = [];
    getState().then((value) {
      var i = selectedStateList.length - 1;
      while (i >= 0) {
        print(i);
        print("${selectedStateList[i].name}");
        if (!value.map((e) => e.id).contains(selectedStateList[i].id)) {
          selectedStateList
              .removeWhere((element) => element.id == selectedStateList[i].id);
        }
        i--;
      }
      removeCity();
    });
  }

  void removeCity() {
    _cities = [];
    cityDataList = [];
    // getState();

    // _states = [];
    // stateDataList = [];
    getCity().then((value) {
      var i = selectedCityList.length - 1;
      while (i >= 0) {
        print(i);
        print("${selectedCityList[i].name}");
        if (!value.map((e) => e.id).contains(selectedCityList[i].id)) {
          selectedCityList
              .removeWhere((element) => element.id == selectedCityList[i].id);
        }
        i--;
      }
    });
  }

  // List<Widget> countrySuggetion(List<StatusModel.StatusModel> countryList) {
  //   List<Widget> countrytemp = [];
  //   // scrollDirection: Axis.vertical,
  //   // physics: BouncingScrollPhysics(),
  //
  //   // List<String> countryList = countryLists.;
  //   for (StatusModel.StatusModel country in countryList) {
  //     countrytemp.add(Container(
  //       child: Container(
  //         margin: const EdgeInsets.symmetric(
  //           horizontal: 10,
  //         ),
  //         decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(5),
  //             border: Border.all(
  //                 color: const Color.fromARGB(255, 225, 223, 223), width: 1)),
  //         child: ListTile(
  //           title: Text(country.name!,
  //               style: TextStyle(
  //                 color: Colors.lightBlueAccent,
  //               )),
  //           iconColor: Colors.black,
  //           leading: Icon(
  //             Icons.location_on_outlined,
  //             color: Colors.lightBlueAccent,
  //           ),
  //           onTap: () {
  //             if (selectedCountryList.contains(country)) {
  //               selectedCountryList.remove(country);
  //               removeState();
  //               setState(() {});
  //             } else {
  //               selectedCountryList.add(country);
  //               _states = [];
  //               stateDataList = [];
  //               getState();
  //               countryfocus = false;
  //               countryController.clear();
  //               setState(() {});
  //             }
  //           },
  //           trailing: selectedCountryList.contains(country)
  //               ? Icon(
  //                   CupertinoIcons.check_mark,
  //                   color: Colors.lightBlueAccent,
  //                 )
  //               : null,
  //         ),
  //       ),
  //     ));
  //   }
  //
  //   return countrytemp;
  // }

  List<Widget> stateSuggetion(List<StatusModel.State> stateList) {
    List<Widget> statetemp = [];
    for (StatusModel.State state in stateList) {
      statetemp.add(Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: const Color.fromARGB(255, 225, 223, 223), width: 1)),
        child: ListTile(
          iconColor: Colors.black,
          leading: Icon(
            Icons.location_on_outlined,
            color: Colors.lightBlueAccent,
          ),
          title: Text(state.name!,
              style: TextStyle(
                color: Colors.lightBlueAccent,
              )),
          onTap: () {
            if (selectedStateList.contains(state)) {
              selectedStateList.remove(state);
              // _cities = [];
              // cityDataList = [];
              // getCity();
              removeCity();

              setState(() {});
            } else {
              selectedStateList.add(state);
              statefocus = false;
              stateController.clear();
              cityDataList = [];
              _cities = [];
              getCity();
            }
            setState(() {});
          },
          trailing: selectedStateList.map((e) => e.id).contains(state.id)
              ? Icon(
                  CupertinoIcons.check_mark,
                  color: Colors.lightBlueAccent,
                )
              : null,
        ),
      ));
    }

    return statetemp;
  }

  List<Widget> citySuggetion(List<StatusModel.City> cityList) {
    List<Widget> citytemp = [];
    for (StatusModel.City city in cityList) {
      citytemp.add(Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: const Color.fromARGB(255, 225, 223, 223), width: 1)),
        child: ListTile(
          title: Text(city.name!,
              style: TextStyle(
                color: Colors.lightBlueAccent,
              )),
          iconColor: Colors.black,
          leading: Icon(
            Icons.location_on_outlined,
            color: Colors.lightBlueAccent,
          ),
          onTap: () {
            if (selectedCityList.contains(city)) {
              selectedCityList.remove(city);
            } else {
              selectedCityList.add(city);
              cityfocus = false;
              cityController.clear();
            }
            setState(() {});
          },
          trailing: selectedCityList.contains(city)
              ? Icon(
                  CupertinoIcons.check_mark,
                  color: Colors.lightBlueAccent,
                )
              : null,
        ),
      ));
    }

    return citytemp;
  }
}

InputDecoration textFiedstyle = InputDecoration(
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.transparent)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.transparent)),
);
BoxDecoration containerStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: const Color.fromARGB(255, 208, 207, 207).withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 2,
      offset: const Offset(0, 0), // changes position of shadow
    ),
  ],
);
