import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:boldo/provider/utils_provider.dart';

import '../../../../constants.dart';
import 'package:boldo/constants.dart';
import 'package:flutter/foundation.dart';

class EmptyAppointmentsState extends StatelessWidget {
  final String size;
  const EmptyAppointmentsState({Key key, @required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (size == "big")
            SvgPicture.asset(
              'assets/images/calendar.svg',
            ),
          const Text(
            "Agrega tu primera cita",
            style: TextStyle(
                color: Constants.extraColor400,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 17,
          ),
          Container(
            child: const Text(
              "Consulta la lista de doctores y \n programá tu primera cita",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Constants.extraColor300,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<UtilsProvider>(context, listen: false)
                  .setSelectedPageIndex(pageIndex: 1);
            },
            child: const Text("Agregar Cita"),
          )
        ],
      ),
    );
  }
}
