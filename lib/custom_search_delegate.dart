import 'package:flutter/material.dart';
import './Measurements.dart';

class CustomSearchDelegate extends SearchDelegate {
  Map<DateTime, List> _events;
  List<dynamic> employee, projectStatus, installer;
  CustomSearchDelegate(
      this._events, this.employee, this.projectStatus, this.installer);
  List<dynamic> _selectedEvents = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryIconTheme:
          Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),
      primaryColor: Color(0xff44aae4),
      hintColor: Colors.white,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Future<List<dynamic>> searchFounds() async {
    _selectedEvents.clear();
    List<dynamic> temp = [];
    _events.forEach((k, v) => temp.addAll(_events[k]));
    for (int i = 0; i < temp.length; i++) {
      if (temp[i]['clientName']
          .toString()
          .toLowerCase()
          .startsWith(query.toString().toLowerCase()))
        _selectedEvents.add(temp[i]);
    }
    return Future.value(_selectedEvents);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Column();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: searchFounds(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.data.length == 0) {
              return Column();
            } else {
              return _buildEventList();
            }
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _selectedEvents == null ? 0 : _selectedEvents.length,
        itemBuilder: (context, index) {
          return Container(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      if (_selectedEvents[index]['projectType'] == "measure") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Measurements(
                              id: _selectedEvents[index]['projectId'],
                              employee: employee,
                              projectStatus: projectStatus,
                              name: 'measure',
                              installer: installer,
                              tabName: "Measure",
                            ),
                          ),
                        );
                      } else if (_selectedEvents[index]['projectType'] ==
                          "install") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Measurements(
                              id: _selectedEvents[index]['projectId'],
                              employee: employee,
                              projectStatus: projectStatus,
                              name: 'install',
                              installer: installer,
                              tabName: "Install",
                            ),
                          ),
                        );
                      }
                    },
                    leading: _selectedEvents[index]['taskStatus'] == 'completed' ||
                            _selectedEvents[index]['taskStatus'] ==
                                'measure complete'
                        ? Container(
                            height: 30,
                            width: 50,
                            child: Image.asset(
                              'lib/assets/Needs_Estimate.png',
                            ),
                          )
                        : _selectedEvents[index]['taskStatus'] ==
                                'install incomplete'
                            ? Container(
                                height: 30,
                                width: 50,
                                child: Image.asset(
                                  'lib/assets/install_incomplete.png',
                                ),
                              )
                            : _selectedEvents[index]['taskStatus'] ==
                                    'needs estimate'
                                ? Container(
                                    height: 30,
                                    width: 50,
                                    child: Image.asset(
                                      'lib/assets/Needs_Estimate.png',
                                    ),
                                  )
                                : _selectedEvents[index]['taskStatus'] ==
                                        'needs install'
                                    ? Container(
                                        height: 30,
                                        width: 50,
                                        child: Image.asset(
                                          'lib/assets/Needs_Install.png',
                                        ),
                                      )
                                    : _selectedEvents[index]['taskStatus'] ==
                                                'assigned' ||
                                            _selectedEvents[index]
                                                    ['taskStatus'] ==
                                                'measure assigned'
                                        ? Container(
                                            height: 30,
                                            width: 50,
                                            child: Image.asset(
                                              'lib/assets/Measure_assigned.png',
                                            ),
                                          )
                                        : _selectedEvents[index]
                                                    ['taskStatus'] ==
                                                'estimate dormant'
                                            ? Container(
                                                height: 30,
                                                width: 50,
                                                child: Image.asset(
                                                  'lib/assets/estimate_dormant.png',
                                                ),
                                              )
                                            : _selectedEvents[index]
                                                        ['taskStatus'] ==
                                                    'install assigned'
                                                ? Container(
                                                    height: 30,
                                                    width: 50,
                                                    child: Image.asset(
                                                      'lib/assets/install_assigned.png',
                                                    ),
                                                  )
                                                : _selectedEvents[index]
                                                            ['taskStatus'] ==
                                                        'measure incomplete'
                                                    ? Container(
                                                        height: 30,
                                                        width: 50,
                                                        child: Image.asset(
                                                          'lib/assets/Measure_incomplete.png',
                                                        ),
                                                      )
                                                    : _selectedEvents[index]['taskStatus'] ==
                                                            'waiting approval'
                                                        ? Container(
                                                            height: 30,
                                                            width: 50,
                                                            child: Image.asset(
                                                              'lib/assets/Waiting_Approval.png',
                                                            ),
                                                          )
                                                        : _selectedEvents[index]
                                                                    ['taskStatus'] ==
                                                                'incomplete'
                                                            ? Container(
                                                                height: 30,
                                                                width: 50,
                                                                child:
                                                                    Image.asset(
                                                                  'lib/assets/install_incomplete.png',
                                                                ),
                                                              )
                                                            : _selectedEvents[index]['taskStatus'] == 'paid' || _selectedEvents[index]['taskStatus'] == null
                                                                ? Container(
                                                                    height: 30,
                                                                    width: 50,
                                                                    child: Image
                                                                        .asset(
                                                                      'lib/assets/Paid.png',
                                                                    ),
                                                                  )
                                                                : _selectedEvents[index]['taskStatus'] == 'created'
                                                                    ? Container(
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            50,
                                                                        child: Image
                                                                            .asset(
                                                                          'lib/assets/Measure_Created.png',
                                                                        ),
                                                                      )
                                                                    : _selectedEvents[index]['taskStatus'] == 'estimate rejected'
                                                                        ? Container(
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                50,
                                                                            child:
                                                                                Image.asset(
                                                                              'lib/assets/estimate_rejected.png',
                                                                            ),
                                                                          )
                                                                        : _selectedEvents[index]['taskStatus'] == 'needs ordering'
                                                                            ? Container(
                                                                                height: 30,
                                                                                width: 50,
                                                                                child: Image.asset(
                                                                                  'lib/assets/needs_ordering.png',
                                                                                ),
                                                                              )
                                                                            : _selectedEvents[index]['taskStatus'] == 'waiting delivery' || _selectedEvents[index]['taskStatus'] == 'ordered' || _selectedEvents[index]['taskStatus'] == 'waiting'
                                                                                ? Container(
                                                                                    height: 30,
                                                                                    width: 50,
                                                                                    child: Image.asset(
                                                                                      'lib/assets/waiting_delivery.png',
                                                                                    ),
                                                                                  )
                                                                                : _selectedEvents[index]['taskStatus'] == 'needs payment'
                                                                                    ? Container(
                                                                                        height: 30,
                                                                                        width: 50,
                                                                                        child: Image.asset(
                                                                                          'lib/assets/Needs_payment.png',
                                                                                        ),
                                                                                      )
                                                                                    : _selectedEvents[index]['taskStatus'] == 'material ready'
                                                                                        ? Container(
                                                                                            height: 30,
                                                                                            width: 50,
                                                                                            child: Image.asset(
                                                                                              'lib/assets/Material_ready.png',
                                                                                            ),
                                                                                          )
                                                                                        : _selectedEvents[index]['taskStatus'] == 'estimated'
                                                                                            ? Container(
                                                                                                height: 30,
                                                                                                width: 50,
                                                                                                child: Image.asset(
                                                                                                  'lib/assets/estimated.png',
                                                                                                ),
                                                                                              )
                                                                                            : _selectedEvents[index]['taskStatus'] == 'material arrived'
                                                                                                ? Container(
                                                                                                    height: 30,
                                                                                                    width: 50,
                                                                                                    child: Image.asset(
                                                                                                      'lib/assets/material_arrived.png',
                                                                                                    ),
                                                                                                  )
                                                                                                : Container(
                                                                                                    height: 30,
                                                                                                    width: 50,
                                                                                                    child: Image.asset(
                                                                                                      'lib/assets/unknown.png',
                                                                                                    ),
                                                                                                  ),
                    title: Text(
                      _selectedEvents[index]['clientName'].toString() == ' ' || _selectedEvents[index]['clientName'].toString() == ''
                          ? '${_selectedEvents[index]['clientAddress']}'
                          : '${_selectedEvents[index]['clientName'].toString()}',
                    ),
                    subtitle: Text(
                        'Address: ${_selectedEvents[index]['clientAddress']}'),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${_selectedEvents[index]['time'].toString().substring(11, 19)}'),
                        Text('${_selectedEvents[index]['date']}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
