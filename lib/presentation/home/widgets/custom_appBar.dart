// ignore_for_file: file_names

import 'package:flutter/material.dart';

PreferredSize customAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(70),
    child: AppBar(
      flexibleSpace: Stack(
        children: [
          Image.asset(
            'assets/images/asd.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/logo-netzoon.png',
                // height: 90,
                width: 190,
                fit: BoxFit.cover,
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Form(
                    child: TextFormField(
                      style: const TextStyle(color: Color(0xFF5776a5)),
                      decoration: const InputDecoration(
                          hintText: 'Search in NetZoon.com',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),

          //  Container(
          //   decoration: BoxDecoration(
          //     color: Color(0xFF5776a5),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Expanded(
          //         child: Image.asset(
          //           'assets/images/logo-netzoon.png',
          //           // height: 90,
          //           width: 170,
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //       // Container(
          //       //   height: 90.h,
          //       //   width: 100.h,
          //       //   child: Image.asset(
          //       //     'assets/images/logo-netzoon.png',
          //       //     fit: BoxFit.fill,
          //       //   ),
          //       // ),

          //       Expanded(
          //         child: Form(
          //           child: TextFormField(
          //             style: const TextStyle(color: Color(0xFF5776a5)),
          //             decoration: const InputDecoration(
          //                 hintText: 'Search in NetZoon.com',
          //                 hintStyle: TextStyle(
          //                   color: Colors.grey,
          //                 ),
          //                 filled: true,
          //                 fillColor: Colors.white,
          //                 border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.all(
          //                     Radius.circular(40),
          //                   ),
          //                 ),
          //                 prefixIcon: Icon(
          //                   Icons.search,
          //                   color: Colors.grey,
          //                 )),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    ),
  );
}
