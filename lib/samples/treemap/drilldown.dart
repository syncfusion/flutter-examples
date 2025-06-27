import 'dart:math' show pow;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Treemap import.
import 'package:syncfusion_flutter_treemap/treemap.dart';

/// Local import.
import '../../../model/sample_view.dart';

/// This sample demonstrates how to add a drill down in treemap.
class TreemapDrilldownSample extends SampleView {
  /// Creates [TreemapDrilldownSample].
  const TreemapDrilldownSample(Key key) : super(key: key);

  @override
  _TreemapDrilldownSampleState createState() => _TreemapDrilldownSampleState();
}

class _TreemapDrilldownSampleState extends SampleViewState
    with SingleTickerProviderStateMixin {
  late List<_WorldPopulationDetails> _worldPopulationDetails;
  late Map<String, Color> _colors;
  late List<TreemapLevel> _levels;
  late bool _isDesktop;
  late bool _isLightTheme;
  late AnimationController _opacityAnimationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _worldPopulationDetails = <_WorldPopulationDetails>[
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Uttar Pradesh',
        populationInThousands: 199812.341,
        color: Color.fromRGBO(204, 99, 130, 1.0),
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Maharashtra',
        populationInThousands: 112374.333,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Bihar',
        populationInThousands: 104099.452,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'West Bengal',
        populationInThousands: 91276.115,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Madhya Pradesh',
        populationInThousands: 72626.809,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Tamil Nadu',
        populationInThousands: 72147.03,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Rajasthan',
        populationInThousands: 68548.437,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Karnataka',
        populationInThousands: 61095.297,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Gujarat',
        populationInThousands: 60439.692,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Andhra Pradesh',
        populationInThousands: 49576.777,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Odisha',
        populationInThousands: 41974.218,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Telangana',
        populationInThousands: 35004,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Kerala',
        populationInThousands: 33406.061,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Jharkhand',
        populationInThousands: 32988.134,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Assam',
        populationInThousands: 31205.576,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Punjab',
        populationInThousands: 27743.338,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Chhattisgarh',
        populationInThousands: 25545.198,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Haryana',
        populationInThousands: 25351.462,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Delhi',
        populationInThousands: 16787.941,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Jammu & Kashmir',
        populationInThousands: 12258.433,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Uttarakhand',
        populationInThousands: 10086.292,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Himachal Pradesh',
        populationInThousands: 6864.602,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Tripura',
        populationInThousands: 3673.917,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Meghalaya',
        populationInThousands: 2966.889,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Manipur',
        populationInThousands: 2855.794,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Nagaland',
        populationInThousands: 1978.502,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Goa',
        populationInThousands: 1458.545,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Arunachal Pradesh',
        populationInThousands: 1383.727,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Puducherry',
        populationInThousands: 1247.953,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Mizoram',
        populationInThousands: 1097.206,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Chandigarh',
        populationInThousands: 1055.45,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Sikkim',
        populationInThousands: 610.577,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Guangdong',
        populationInThousands: 126010,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Shandong',
        populationInThousands: 101530,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Henan',
        populationInThousands: 99370,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Jiangsu',
        populationInThousands: 84750,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Sichuan',
        populationInThousands: 83670,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Hebei',
        populationInThousands: 74610,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Hunan',
        populationInThousands: 66440,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Zheijiang',
        populationInThousands: 64570,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Anhui',
        populationInThousands: 61030,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Hubei',
        populationInThousands: 57750,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Guangxi',
        populationInThousands: 50130,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Yunnan',
        populationInThousands: 47210,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Jiangsi',
        populationInThousands: 45190,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Liaoning',
        populationInThousands: 42590,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Fujian',
        populationInThousands: 41540,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Shaanxi',
        populationInThousands: 39530,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Guizhou',
        populationInThousands: 38560,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Shanxi',
        populationInThousands: 34920,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Chongqing',
        populationInThousands: 32050,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Heilongjiang',
        populationInThousands: 31850,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Xinjiang',
        populationInThousands: 25850,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Gansu',
        populationInThousands: 25020,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Shanghai',
        populationInThousands: 24870,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Jilin',
        populationInThousands: 24070,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Inner Mongolia',
        populationInThousands: 24040,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Beijing',
        populationInThousands: 21890,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Tianjin',
        populationInThousands: 13870,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Hainan',
        populationInThousands: 10080,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Ningxia',
        populationInThousands: 7200,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Qinghai',
        populationInThousands: 59200,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Tibet',
        populationInThousands: 36500,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Indonesia',
        populationInThousands: 273523.615,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Pakisthan',
        populationInThousands: 220892.34,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Bangladesh',
        populationInThousands: 164689.383,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Japan',
        populationInThousands: 126476.461,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Philippines',
        populationInThousands: 109581.078,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Vietnam',
        populationInThousands: 97338.579,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Turkey',
        populationInThousands: 84339.067,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Iran',
        populationInThousands: 83992.949,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Thailand',
        populationInThousands: 69799.978,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Myanmar',
        populationInThousands: 54409.8,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'South Korea',
        populationInThousands: 51269.185,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Iraq',
        populationInThousands: 40222.493,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Afghanistan',
        populationInThousands: 38928.346,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Saudi Arabia',
        populationInThousands: 34813.871,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Uzbekistan',
        populationInThousands: 33469.203,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Malaysia',
        populationInThousands: 32365.999,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Yemen',
        populationInThousands: 29825.964,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Nepal',
        populationInThousands: 29136.808,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Tajikistan',
        populationInThousands: 25778.816,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Israel',
        populationInThousands: 8655.535,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Hong Kong',
        populationInThousands: 7496.981,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Laos',
        populationInThousands: 7275.56,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Lebanon',
        populationInThousands: 6825.445,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Kyrgyzstan',
        populationInThousands: 6524.195,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Turkmenistan',
        populationInThousands: 6031.2,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Singapore',
        populationInThousands: 5850.342,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'State of Palestine',
        populationInThousands: 5101.414,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Oman',
        populationInThousands: 5106.626,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Kuwait',
        populationInThousands: 4270.571,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Georgia',
        populationInThousands: 3989.167,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Mongolia',
        populationInThousands: 3278.29,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Armenia',
        populationInThousands: 2963.243,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Qatar',
        populationInThousands: 2881.053,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Lagos',
        populationInThousands: 14862,
        color: Color.fromRGBO(44, 90, 128, 1.0),
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Kano',
        populationInThousands: 4103,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ibadan',
        populationInThousands: 3649,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Kaduna',
        populationInThousands: 1133,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Port Harcourt',
        populationInThousands: 3171,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Benin City',
        populationInThousands: 1782,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Maiduguri',
        populationInThousands: 803,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Zaria',
        populationInThousands: 736,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Aba',
        populationInThousands: 1114,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Jos',
        populationInThousands: 917,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ilorin',
        populationInThousands: 974,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Oyo',
        populationInThousands: 441,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Uyo',
        populationInThousands: 1200,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Enugu',
        populationInThousands: 795,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Lokoja',
        populationInThousands: 741,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Abuja',
        populationInThousands: 3464,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Sokoto',
        populationInThousands: 662,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Onitsha',
        populationInThousands: 1483,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Warri',
        populationInThousands: 899,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ikorodu',
        populationInThousands: 989,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Okene',
        populationInThousands: 478,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Igbidu',
        populationInThousands: 465,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Calabar',
        populationInThousands: 605,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Katsina',
        populationInThousands: 487,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ado Ekiti',
        populationInThousands: 497,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Akure',
        populationInThousands: 691,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Bauchi',
        populationInThousands: 621,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ikeja',
        populationInThousands: 313.196,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Makurdi',
        populationInThousands: 422,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Minna',
        populationInThousands: 463,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Effon Alaaye',
        populationInThousands: 396,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ilesa',
        populationInThousands: 371,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Umuahia',
        populationInThousands: 817,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ondo',
        populationInThousands: 445,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ikot Ekpene',
        populationInThousands: 254.806,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ife',
        populationInThousands: 385,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Gombe',
        populationInThousands: 529,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Jimeta',
        populationInThousands: 248.148,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Atani',
        populationInThousands: 230,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Gusau',
        populationInThousands: 226.857,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Mubi',
        populationInThousands: 225.705,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ikire',
        populationInThousands: 222.16,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Owerri',
        populationInThousands: 908,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Shagamu',
        populationInThousands: 214.558,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ijebu-Ode	',
        populationInThousands: 209.175,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ugep',
        populationInThousands: 200.276,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Nnewi',
        populationInThousands: 1114,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ise-Ekiti',
        populationInThousands: 190.063,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ila Orangun',
        populationInThousands: 179.192,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Saki',
        populationInThousands: 178.677,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Bida',
        populationInThousands: 171.656,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Awka',
        populationInThousands: 167.738,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ado-Ekiti',
        populationInThousands: 497,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Inisa',
        populationInThousands: 164.161,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Suleja',
        populationInThousands: 162.135,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Sapele',
        populationInThousands: 161.686,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Osogbo',
        populationInThousands: 731,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Kisi',
        populationInThousands: 155.51,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Gbongan',
        populationInThousands: 139.485,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ejigbo',
        populationInThousands: 138.357,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Funtua',
        populationInThousands: 136.811,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Igboho',
        populationInThousands: 136.764,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Buguma',
        populationInThousands: 135.404,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ikirun',
        populationInThousands: 134.24,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Abakaliki',
        populationInThousands: 602,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Okrika',
        populationInThousands: 133.271,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Amaigbo',
        populationInThousands: 127.3,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Lafia',
        populationInThousands: 348,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Gashua',
        populationInThousands: 125.817,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Modakeke',
        populationInThousands: 119.529,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Tigray',
        populationInThousands: 7070,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Afar',
        populationInThousands: 1812.002,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Amhara',
        populationInThousands: 108113.15,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Dire Dawa',
        populationInThousands: 493,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Gambela',
        populationInThousands: 435.999,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Benishangul Gumuz',
        populationInThousands: 1127.001,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Oromia',
        populationInThousands: 3500,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Addis Ababa',
        populationInThousands: 5006,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Egypt',
        populationInThousands: 102334.404,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kinshasa',
        populationInThousands: 11575,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kongo Central',
        populationInThousands: 5575,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kwango',
        populationInThousands: 1994.036,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kwilu',
        populationInThousands: 5174.718,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Mai-Ndombe',
        populationInThousands: 1768.327,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kasaï',
        populationInThousands: 3199.891,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kasaï-Central',
        populationInThousands: 2976.806,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kasaï-Oriental',
        populationInThousands: 2702.43,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Lomami',
        populationInThousands: 2048.839,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Sankuru',
        populationInThousands: 1374.239,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Maniema',
        populationInThousands: 2333,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'South Kivu',
        populationInThousands: 5772,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'North Kivu',
        populationInThousands: 6655,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Ituri',
        populationInThousands: 4241.236,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Haut-Uele',
        populationInThousands: 1920.867,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Tshopo',
        populationInThousands: 2614.63,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Bas-Uele',
        populationInThousands: 1093.845,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Nord-Ubangi',
        populationInThousands: 1482.076,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Mongala',
        populationInThousands: 1793.564,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Sud-Ubangi',
        populationInThousands: 2744.345,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Équateur',
        populationInThousands: 1626.606,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Tshuapa',
        populationInThousands: 1316.855,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Tanganyika',
        populationInThousands: 2482.001,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Haut-Lomami',
        populationInThousands: 2540.127,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Lualaba',
        populationInThousands: 1677.288,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Haut-Katanga',
        populationInThousands: 3960.945,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Tanzania',
        populationInThousands: 59734.218,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'South Africa',
        populationInThousands: 59308.69,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Kenya',
        populationInThousands: 53771.296,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Uganda',
        populationInThousands: 45741.007,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Algeria',
        populationInThousands: 43851.044,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Sudan',
        populationInThousands: 43849.26,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Morocco',
        populationInThousands: 36910.56,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Angola',
        populationInThousands: 32866.272,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Mozambique',
        populationInThousands: 31255.435,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ghana',
        populationInThousands: 31072.94,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Madagascar',
        populationInThousands: 27.691,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Cameroon',
        populationInThousands: 26545.863,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ivory Coast',
        populationInThousands: 26378.274,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Niger',
        populationInThousands: 24206.644,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Burkina Faso',
        populationInThousands: 20903.273,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Mali',
        populationInThousands: 20250.833,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Malawi',
        populationInThousands: 19129.952,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Zambia',
        populationInThousands: 18383.955,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Senegal',
        populationInThousands: 16743.927,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Chad',
        populationInThousands: 16425.864,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Somalia',
        populationInThousands: 15893.222,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Zimbabwe',
        populationInThousands: 14862.924,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Guinea',
        populationInThousands: 13132.795,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Rwanda',
        populationInThousands: 12952.218,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Benin',
        populationInThousands: 12123.2,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Tunisia',
        populationInThousands: 11818.619,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Burundi',
        populationInThousands: 11890.784,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'South Sudan',
        populationInThousands: 11193.725,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Togo',
        populationInThousands: 8278.724,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Sierra Leone',
        populationInThousands: 7976.983,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Libya',
        populationInThousands: 6871.292,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Congo',
        populationInThousands: 5518.087,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Liberia',
        populationInThousands: 5057.681,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Central African Republic',
        populationInThousands: 4829.767,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Mauritania',
        populationInThousands: 4649.658,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Eritrea',
        populationInThousands: 3546.421,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Namibia',
        populationInThousands: 2540.905,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Gambia',
        populationInThousands: 2416.668,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Botswana',
        populationInThousands: 2351.627,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Gabon',
        populationInThousands: 2225.734,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Lesotho',
        populationInThousands: 2142.249,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Guinea-Bissau',
        populationInThousands: 1968.001,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Equatorial Guinea',
        populationInThousands: 1402.985,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Mauritius',
        populationInThousands: 1271.768,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Eswatini',
        populationInThousands: 1160.164,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Djibouti',
        populationInThousands: 988,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Réunion',
        populationInThousands: 895.312,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Comoros',
        populationInThousands: 869.601,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Western Sahara',
        populationInThousands: 597.339,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Cabo Verde',
        populationInThousands: 555.987,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Mayotte',
        populationInThousands: 272.815,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Sao Tome & Principe',
        populationInThousands: 219.159,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Seychelles',
        populationInThousands: 98.347,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Saint Helena',
        populationInThousands: 6.077,
      ),
      const _WorldPopulationDetails(
        continent: 'Europe',
        populationInThousands: 747636.026,
        color: Color.fromRGBO(255, 100, 121, 1.0),
      ),
    ];

    _levels = _getTreemapLevels();
    _colors = <String, Color>{
      'Asia': const Color.fromRGBO(74, 166, 167, 1.0),
      'Africa': const Color.fromRGBO(48, 91, 110, 1.0),
      'Europe': const Color.fromRGBO(215, 160, 68, 1.0),
    };
    _opacityAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _opacityAnimation = CurvedAnimation(
      parent: _opacityAnimationController,
      curve: Curves.linear,
    );
    super.initState();
  }

  @override
  void dispose() {
    _opacityAnimationController.dispose();
    _worldPopulationDetails.clear();
    _levels.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isLightTheme = themeData.colorScheme.brightness == Brightness.light;
    _isDesktop =
        kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.linux ||
        themeData.platform == TargetPlatform.windows;
    return Center(
      child: Padding(
        padding:
            MediaQuery.of(context).orientation == Orientation.portrait ||
                _isDesktop
            ? const EdgeInsets.all(12.5)
            : const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text(
              'Most populated continents 2021',
              style: themeData.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: SfTreemap(
                  dataCount: _worldPopulationDetails.length,
                  weightValueMapper: (int index) {
                    return _worldPopulationDetails[index].populationInThousands;
                  },
                  enableDrilldown: true,
                  breadcrumbs: TreemapBreadcrumbs(
                    builder:
                        (
                          BuildContext context,
                          TreemapTile tile,
                          bool isCurrent,
                        ) {
                          final String breadcrumbText = tile.group == 'Home'
                              ? 'Continents'
                              : tile.group;
                          final Widget current = AnimatedDefaultTextStyle(
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  color: _isLightTheme
                                      ? const Color.fromRGBO(10, 10, 10, 1)
                                      : const Color.fromRGBO(255, 255, 255, 1),
                                  fontWeight: isCurrent && tile.group != 'Home'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                            duration: const Duration(milliseconds: 500),
                            child: Text(breadcrumbText),
                          );

                          if (tile.group == 'Home') {
                            if (!isCurrent) {
                              _opacityAnimationController.forward();
                            } else {
                              _opacityAnimationController.reverse();
                            }

                            return FadeTransition(
                              opacity: _opacityAnimation,
                              child: current,
                            );
                          }

                          return current;
                        },
                  ),
                  tooltipSettings: TreemapTooltipSettings(
                    color: _isLightTheme
                        ? const Color.fromRGBO(45, 45, 45, 1)
                        : const Color.fromRGBO(242, 242, 242, 1),
                  ),
                  levels: _levels,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TreemapLevel> _getTreemapLevels() {
    return <TreemapLevel>[
      TreemapLevel(
        groupMapper: (int index) => _worldPopulationDetails[index].continent,
        colorValueMapper: (TreemapTile tile) {
          return _colors[_worldPopulationDetails[tile.indices[0]].continent];
        },
        labelBuilder: (BuildContext context, TreemapTile tile) {
          return _buildParentTileLabels(tile);
        },
        itemBuilder: (BuildContext context, TreemapTile tile) {
          return _buildItemBuilder(tile);
        },
      ),
      TreemapLevel(
        groupMapper: (int index) => _worldPopulationDetails[index].country,
        colorValueMapper: (TreemapTile tile) {
          return _colors[_worldPopulationDetails[tile.indices[0]].continent];
        },
        tooltipBuilder: (BuildContext context, TreemapTile tile) {
          return _buildTooltipBuilder(tile);
        },
        labelBuilder: (BuildContext context, TreemapTile tile) {
          return _buildDescendantsLabels(tile);
        },
        itemBuilder: (BuildContext context, TreemapTile tile) {
          return _buildItemBuilder(tile);
        },
      ),
      TreemapLevel(
        groupMapper: (int index) => _worldPopulationDetails[index].state,
        colorValueMapper: (TreemapTile tile) {
          return _colors[_worldPopulationDetails[tile.indices[0]].continent];
        },
        labelBuilder: (BuildContext context, TreemapTile tile) {
          return _buildDescendantsLabels(tile);
        },
        tooltipBuilder: (BuildContext context, TreemapTile tile) {
          return _buildTooltipBuilder(tile);
        },
      ),
    ];
  }

  Widget _buildParentTileLabels(TreemapTile tile) {
    final Brightness brightness = ThemeData.estimateBrightnessForColor(
      tile.color,
    );
    final Color color = brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 4, top: 4, right: 4),
            child: Text(
              tile.group,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              'Population : ' +
                  (tile.weight / pow(10, 6)).toStringAsFixed(2) +
                  'B',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescendantsLabels(TreemapTile tile) {
    final Brightness brightness = ThemeData.estimateBrightnessForColor(
      tile.color,
    );
    final Color color = brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 4.0, right: 4),
        child: Text(
          tile.group,
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(fontSize: 11, color: color),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildItemBuilder(TreemapTile tile) {
    if (tile.hasDescendants) {
      return const Padding(
        padding: EdgeInsets.only(right: 4, bottom: 4),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Icon(Icons.add_circle_outline, size: 20, color: Colors.white),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildTooltipBuilder(TreemapTile tile) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 8.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            child: RichText(
              text: TextSpan(
                text: _levels.indexOf(tile.level) == 1 ? 'Country' : 'State',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  height: 1.5,
                  color: _isLightTheme
                      ? const Color.fromRGBO(255, 255, 255, 0.75)
                      : const Color.fromRGBO(10, 10, 10, 0.75),
                ),
                children: const <TextSpan>[TextSpan(text: '\nPopulation')],
              ),
            ),
          ),
          const SizedBox(width: 15.0),
          SizedBox(
            child: RichText(
              text: TextSpan(
                text: tile.group,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: _isLightTheme
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : const Color.fromRGBO(10, 10, 10, 1),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        '\n' +
                        ((_levels.indexOf(tile.level) == 1
                                    ? tile.weight
                                    : _worldPopulationDetails[tile.indices[0]]
                                          .populationInThousands) /
                                pow(10, 3))
                            .toStringAsFixed(2) +
                        'M',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorldPopulationDetails {
  const _WorldPopulationDetails({
    required this.continent,
    required this.populationInThousands,
    this.country,
    this.state,
    this.color,
  });

  final String continent;
  final String? country;
  final String? state;
  final double populationInThousands;
  final Color? color;
}
