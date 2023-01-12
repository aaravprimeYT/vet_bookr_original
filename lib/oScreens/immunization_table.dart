import 'package:flutter/material.dart';

class ImmunizationTable extends StatelessWidget {
  const ImmunizationTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFD9B3),
      body: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 6),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 33.0,
                minWidth: 375,
              ),
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Color(0xff49263E)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 115),
                  child: Text("Immunization Record",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Table(
              columnWidths: {
                0: const FlexColumnWidth(1),
                1: const FlexColumnWidth(2),
                2: const FlexColumnWidth(2),
                3: const FlexColumnWidth(1)
              },
              //defaultColumnWidth: FixedColumnWidth(100),
              border: TableBorder.all(
                  color: const Color(0xffFF8B6A),
                  style: BorderStyle.solid,
                  width: 2),
              children: [
                TableRow(children: [
                  Column(
                    children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.fill,
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.all(3.0),
                          color: const Color(0xffFF8B6A),
                          alignment: Alignment.center,
                          child: const Text(
                            'Date',
                            style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      height: 40,
                      color: const Color(0xffFF8B6A),
                      alignment: Alignment.center,
                      child: const SizedBox(height: 45,
                        child: Text(
                          'Vaccination \nType',
                          style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      height: 40,
                      color: const Color(0xffFF8B6A),
                      alignment: Alignment.center,
                      child: const Text(
                        'Vet/Clinic Provider',
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      height: 40,
                      color: const Color(0xffFF8B6A),
                      alignment: Alignment.center,
                      child: const Text(
                        'Next Due Date',
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.fill,
                        child: Container(
                          color: const Color(0xffFAEDE1),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              style: const TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Column(children: [
                    TextFormField(
                      style: const TextStyle(
                          backgroundColor: Color(0xffFAEDE1), fontSize: 10.0),
                    )
                  ]),
                ]),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Column(children: [
                    TextFormField(
                      style: const TextStyle(
                          backgroundColor: Color(0xffFAEDE1), fontSize: 10.0),
                    )
                  ]),
                ]),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Column(children: [
                    TextFormField(
                      style: const TextStyle(
                          backgroundColor: Color(0xffFAEDE1), fontSize: 10.0),
                    )
                  ]),
                ]),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Column(children: [
                    TextFormField(
                      style: const TextStyle(
                          backgroundColor: Color(0xffFAEDE1), fontSize: 10.0),
                    )
                  ]),
                ]),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Column(children: [
                    TextFormField(
                      style: const TextStyle(
                          backgroundColor: Color(0xffFAEDE1), fontSize: 10.0),
                    )
                  ]),
                ]),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Column(children: [
                    TextFormField(
                      style: const TextStyle(
                          backgroundColor: Color(0xffFAEDE1), fontSize: 10.0),
                    )
                  ]),
                ]),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Column(children: [
                    TextFormField(
                      style: const TextStyle(
                          backgroundColor: Color(0xffFAEDE1), fontSize: 10.0),
                    )
                  ]),
                ]),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Column(children: [
                    TextFormField(
                      style: const TextStyle(
                          backgroundColor: Color(0xffFAEDE1), fontSize: 10.0),
                    )
                  ]),
                ]),
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      color: const Color(0xffFAEDE1),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Column(children: [
                    TextFormField(
                      style: const TextStyle(
                          backgroundColor: Color(0xffFAEDE1), fontSize: 10.0),
                    )
                  ]),
                ]),
              ],
            ),)
          ,
        ]
        ,
      )
      ,
    );
  }
}
