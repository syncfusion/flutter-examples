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

class _TreemapDrilldownSampleState extends SampleViewState {
  late List<_WorldPopulationDetails> _worldPopulationDetails;
  late Map<String, Color> _colors;
  late List<TreemapLevel> _levels;
  late bool _isDesktop;
  late bool _isLightTheme;

  @override
  void initState() {
    _worldPopulationDetails = <_WorldPopulationDetails>[
      const _WorldPopulationDetails(
          continent: 'Asia',
          country: 'India',
          state: 'Uttar Pradesh',
          populationInCrores: 199812.341,
          color: Color.fromRGBO(204, 99, 130, 1.0)),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Maharashtra',
        populationInCrores: 112374.333,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Bihar',
        populationInCrores: 104099.452,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'West Bengal',
        populationInCrores: 91276.115,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Madhya Pradesh',
        populationInCrores: 72626.809,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Tamil Nadu',
        populationInCrores: 72147.03,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Rajasthan',
        populationInCrores: 68548.437,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Karnataka',
        populationInCrores: 61095.297,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Gujarat',
        populationInCrores: 60439.692,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Andhra Pradesh',
        populationInCrores: 49576.777,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Odisha',
        populationInCrores: 41974.218,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Telangana',
        populationInCrores: 35004,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Kerala',
        populationInCrores: 33406.061,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Jharkhand',
        populationInCrores: 32988.134,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Assam',
        populationInCrores: 31205.576,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Punjab',
        populationInCrores: 27743.338,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Chhattisgarh',
        populationInCrores: 25545.198,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Haryana',
        populationInCrores: 25351.462,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Delhi',
        populationInCrores: 16787.941,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Jammu & Kashmir',
        populationInCrores: 12258.433,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Uttarakhand',
        populationInCrores: 10086.292,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Himachal Pradesh',
        populationInCrores: 6864.602,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Tripura',
        populationInCrores: 3673.917,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Meghalaya',
        populationInCrores: 2966.889,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Manipur',
        populationInCrores: 2855.794,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Nagaland',
        populationInCrores: 1978.502,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Goa',
        populationInCrores: 1458.545,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Arunachal Pradesh',
        populationInCrores: 1383.727,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Puducherry',
        populationInCrores: 1247.953,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Mizoram',
        populationInCrores: 1097.206,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Chandigarh',
        populationInCrores: 1055.45,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'India',
        state: 'Sikkim',
        populationInCrores: 610.577,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Guangdong',
        populationInCrores: 126010,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Shandong',
        populationInCrores: 101530,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Henan',
        populationInCrores: 99370,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Jiangsu',
        populationInCrores: 84750,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Sichuan',
        populationInCrores: 83670,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Hebei',
        populationInCrores: 74610,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Hunan',
        populationInCrores: 66440,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Zheijiang',
        populationInCrores: 64570,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Anhui',
        populationInCrores: 61030,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Hubei',
        populationInCrores: 57750,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Guangxi',
        populationInCrores: 50130,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Yunnan',
        populationInCrores: 47210,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Jiangsi',
        populationInCrores: 45190,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Liaoning',
        populationInCrores: 42590,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Fujian',
        populationInCrores: 41540,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Shaanxi',
        populationInCrores: 39530,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Guizhou',
        populationInCrores: 38560,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Shanxi',
        populationInCrores: 34920,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Chongqing',
        populationInCrores: 32050,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Heilongjiang',
        populationInCrores: 31850,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Xinjiang',
        populationInCrores: 25850,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Gansu',
        populationInCrores: 25020,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Shanghai',
        populationInCrores: 24870,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Jilin',
        populationInCrores: 24070,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Inner Mongolia',
        populationInCrores: 24040,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Beijing',
        populationInCrores: 21890,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Tianjin',
        populationInCrores: 13870,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Hainan',
        populationInCrores: 10080,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Ningxia',
        populationInCrores: 7200,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Qinghai',
        populationInCrores: 59200,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'China',
        state: 'Tibet',
        populationInCrores: 36500,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Indonesia',
        populationInCrores: 273523.615,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Pakisthan',
        populationInCrores: 220892.34,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Bangladesh',
        populationInCrores: 164689.383,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Japan',
        populationInCrores: 126476.461,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Philippines',
        populationInCrores: 109581.078,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Vietnam',
        populationInCrores: 97338.579,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Turkey',
        populationInCrores: 84339.067,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Iran',
        populationInCrores: 83992.949,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Thailand',
        populationInCrores: 69799.978,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Myanmar',
        populationInCrores: 54409.8,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'South Korea',
        populationInCrores: 51269.185,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Iraq',
        populationInCrores: 40222.493,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Afghanistan',
        populationInCrores: 38928.346,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Saudi Arabia',
        populationInCrores: 34813.871,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Uzbekistan',
        populationInCrores: 33469.203,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Malaysia',
        populationInCrores: 32365.999,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Yemen',
        populationInCrores: 29825.964,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Nepal',
        populationInCrores: 29136.808,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Tajikistan',
        populationInCrores: 25778.816,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Israel',
        populationInCrores: 8655.535,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Hong Kong',
        populationInCrores: 7496.981,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Laos',
        populationInCrores: 7275.56,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Lebanon',
        populationInCrores: 6825.445,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Kyrgyzstan',
        populationInCrores: 6524.195,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Turkmenistan',
        populationInCrores: 6031.2,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Singapore',
        populationInCrores: 5850.342,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'State of Palestine',
        populationInCrores: 5101.414,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Oman',
        populationInCrores: 5106.626,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Kuwait',
        populationInCrores: 4270.571,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Georgia',
        populationInCrores: 3989.167,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Mongolia',
        populationInCrores: 3278.29,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Armenia',
        populationInCrores: 2963.243,
      ),
      const _WorldPopulationDetails(
        continent: 'Asia',
        country: 'Qatar',
        populationInCrores: 2881.053,
      ),
      const _WorldPopulationDetails(
          continent: 'Africa',
          country: 'Nigeria',
          state: 'Lagos',
          populationInCrores: 14862,
          color: Color.fromRGBO(44, 90, 128, 1.0)),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Kano',
        populationInCrores: 4103,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ibadan',
        populationInCrores: 3649,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Kaduna',
        populationInCrores: 1133,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Port Harcourt',
        populationInCrores: 3171,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Benin City',
        populationInCrores: 1782,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Maiduguri',
        populationInCrores: 803,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Zaria',
        populationInCrores: 736,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Aba',
        populationInCrores: 1114,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Jos',
        populationInCrores: 917,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ilorin',
        populationInCrores: 974,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Oyo',
        populationInCrores: 441,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Uyo',
        populationInCrores: 1200,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Enugu',
        populationInCrores: 795,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Lokoja',
        populationInCrores: 741,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Abuja',
        populationInCrores: 3464,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Sokoto',
        populationInCrores: 662,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Onitsha',
        populationInCrores: 1483,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Warri',
        populationInCrores: 899,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ikorodu',
        populationInCrores: 989,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Okene',
        populationInCrores: 478,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Igbidu',
        populationInCrores: 465,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Calabar',
        populationInCrores: 605,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Katsina',
        populationInCrores: 487,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ado Ekiti',
        populationInCrores: 497,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Akure',
        populationInCrores: 691,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Bauchi',
        populationInCrores: 621,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ikeja',
        populationInCrores: 313.196,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Makurdi',
        populationInCrores: 422,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Minna',
        populationInCrores: 463,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Effon Alaaye',
        populationInCrores: 396,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ilesa',
        populationInCrores: 371,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Umuahia',
        populationInCrores: 817,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ondo',
        populationInCrores: 445,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ikot Ekpene',
        populationInCrores: 254.806,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ife',
        populationInCrores: 385,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Gombe',
        populationInCrores: 529,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Jimeta',
        populationInCrores: 248.148,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Atani',
        populationInCrores: 230,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Gusau',
        populationInCrores: 226.857,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Mubi',
        populationInCrores: 225.705,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ikire',
        populationInCrores: 222.16,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Owerri',
        populationInCrores: 908,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Shagamu',
        populationInCrores: 214.558,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ijebu-Ode	',
        populationInCrores: 209.175,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ugep',
        populationInCrores: 200.276,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Nnewi',
        populationInCrores: 1114,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ise-Ekiti',
        populationInCrores: 190.063,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ila Orangun',
        populationInCrores: 179.192,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Saki',
        populationInCrores: 178.677,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Bida',
        populationInCrores: 171.656,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Awka',
        populationInCrores: 167.738,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ado-Ekiti',
        populationInCrores: 497,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Inisa',
        populationInCrores: 164.161,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Suleja',
        populationInCrores: 162.135,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Sapele',
        populationInCrores: 161.686,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Osogbo',
        populationInCrores: 731,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Kisi',
        populationInCrores: 155.51,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Gbongan',
        populationInCrores: 139.485,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ejigbo',
        populationInCrores: 138.357,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Funtua',
        populationInCrores: 136.811,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Igboho',
        populationInCrores: 136.764,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Buguma',
        populationInCrores: 135.404,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Ikirun',
        populationInCrores: 134.24,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Abakaliki',
        populationInCrores: 602,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Okrika',
        populationInCrores: 133.271,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Amaigbo',
        populationInCrores: 127.3,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Lafia',
        populationInCrores: 348,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Gashua',
        populationInCrores: 125.817,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Nigeria',
        state: 'Modakeke',
        populationInCrores: 119.529,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Tigray',
        populationInCrores: 7070,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Afar',
        populationInCrores: 1812.002,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Amhara',
        populationInCrores: 108113.15,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Dire Dawa',
        populationInCrores: 493,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Gambela',
        populationInCrores: 435.999,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Benishangul Gumuz',
        populationInCrores: 1127.001,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Oromia',
        populationInCrores: 3500,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ethiopia',
        state: 'Addis Ababa',
        populationInCrores: 5006,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Egypt',
        populationInCrores: 102334.404,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kinshasa',
        populationInCrores: 11575,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kongo Central',
        populationInCrores: 5575,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kwango',
        populationInCrores: 1994.036,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kwilu',
        populationInCrores: 5174.718,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Mai-Ndombe',
        populationInCrores: 1768.327,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kasaï',
        populationInCrores: 3199.891,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kasaï-Central',
        populationInCrores: 2976.806,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Kasaï-Oriental',
        populationInCrores: 2702.43,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Lomami',
        populationInCrores: 2048.839,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Sankuru',
        populationInCrores: 1374.239,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Maniema',
        populationInCrores: 2333,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'South Kivu',
        populationInCrores: 5772,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'North Kivu',
        populationInCrores: 6655,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Ituri',
        populationInCrores: 4241.236,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Haut-Uele',
        populationInCrores: 1920.867,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Tshopo',
        populationInCrores: 2614.63,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Bas-Uele',
        populationInCrores: 1093.845,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Nord-Ubangi',
        populationInCrores: 1482.076,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Mongala',
        populationInCrores: 1793.564,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Sud-Ubangi',
        populationInCrores: 2744.345,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Équateur',
        populationInCrores: 1626.606,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Tshuapa',
        populationInCrores: 1316.855,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Tanganyika',
        populationInCrores: 2482.001,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Haut-Lomami',
        populationInCrores: 2540.127,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Lualaba',
        populationInCrores: 1677.288,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'DR Congo',
        state: 'Haut-Katanga',
        populationInCrores: 3960.945,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Tanzania',
        populationInCrores: 59734.218,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'South Africa',
        populationInCrores: 59308.69,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Kenya',
        populationInCrores: 53771.296,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Uganda',
        populationInCrores: 45741.007,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Algeria',
        populationInCrores: 43851.044,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Sudan',
        populationInCrores: 43849.26,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Morocco',
        populationInCrores: 36910.56,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Angola',
        populationInCrores: 32866.272,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Mozambique',
        populationInCrores: 31255.435,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ghana',
        populationInCrores: 31072.94,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Madagascar',
        populationInCrores: 27.691,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Cameroon',
        populationInCrores: 26545.863,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Ivory Coast',
        populationInCrores: 26378.274,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Niger',
        populationInCrores: 24206.644,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Burkina Faso',
        populationInCrores: 20903.273,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Mali',
        populationInCrores: 20250.833,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Malawi',
        populationInCrores: 19129.952,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Zambia',
        populationInCrores: 18383.955,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Senegal',
        populationInCrores: 16743.927,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Chad',
        populationInCrores: 16425.864,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Somalia',
        populationInCrores: 15893.222,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Zimbabwe',
        populationInCrores: 14862.924,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Guinea',
        populationInCrores: 13132.795,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Rwanda',
        populationInCrores: 12952.218,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Benin',
        populationInCrores: 12123.2,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Tunisia',
        populationInCrores: 11818.619,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Burundi',
        populationInCrores: 11890.784,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'South Sudan',
        populationInCrores: 11193.725,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Togo',
        populationInCrores: 8278.724,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Sierra Leone',
        populationInCrores: 7976.983,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Libya',
        populationInCrores: 6871.292,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Congo',
        populationInCrores: 5518.087,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Liberia',
        populationInCrores: 5057.681,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Central African Republic',
        populationInCrores: 4829.767,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Mauritania',
        populationInCrores: 4649.658,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Eritrea',
        populationInCrores: 3546.421,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Namibia',
        populationInCrores: 2540.905,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Gambia',
        populationInCrores: 2416.668,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Botswana',
        populationInCrores: 2351.627,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Gabon',
        populationInCrores: 2225.734,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Lesotho',
        populationInCrores: 2142.249,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Guinea-Bissau',
        populationInCrores: 1968.001,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Equatorial Guinea',
        populationInCrores: 1402.985,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Mauritius',
        populationInCrores: 1271.768,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Eswatini',
        populationInCrores: 1160.164,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Djibouti',
        populationInCrores: 988,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Réunion',
        populationInCrores: 895.312,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Comoros',
        populationInCrores: 869.601,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Western Sahara',
        populationInCrores: 597.339,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Cabo Verde',
        populationInCrores: 555.987,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Mayotte',
        populationInCrores: 272.815,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Sao Tome & Principe',
        populationInCrores: 219.159,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Seychelles',
        populationInCrores: 98.347,
      ),
      const _WorldPopulationDetails(
        continent: 'Africa',
        country: 'Saint Helena',
        populationInCrores: 6.077,
      ),
      const _WorldPopulationDetails(
          continent: 'Europe',
          populationInCrores: 747636.026,
          color: Color.fromRGBO(255, 100, 121, 1.0)),
    ];

    _levels = _getTreemapLevels();
    _colors = <String, Color>{
      'Asia': const Color.fromRGBO(74, 166, 167, 1.0),
      'Africa': const Color.fromRGBO(48, 91, 110, 1.0),
      'Europe': const Color.fromRGBO(215, 160, 68, 1.0),
    };
    super.initState();
  }

  @override
  void dispose() {
    _worldPopulationDetails.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isLightTheme = themeData.brightness == Brightness.light;
    _isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.linux ||
        themeData.platform == TargetPlatform.windows;
    return Center(
      child: Padding(
        padding: MediaQuery.of(context).orientation == Orientation.portrait ||
                _isDesktop
            ? const EdgeInsets.all(12.5)
            : const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text(
              'Most populated continents 2021',
              style: themeData.textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: SfTreemap(
                  dataCount: _worldPopulationDetails.length,
                  weightValueMapper: (int index) {
                    return _worldPopulationDetails[index].populationInCrores;
                  },
                  enableDrilldown: true,
                  breadcrumbs: TreemapBreadcrumbs(
                    builder: (BuildContext context, TreemapTile tile,
                        bool isCurrent) {
                      final String breadcrumbText = tile.group == 'Home'
                          ? 'Most populated continents'
                          : tile.group;
                      return Text(
                        breadcrumbText,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            color: _isLightTheme
                                ? const Color.fromRGBO(10, 10, 10, 1)
                                : const Color.fromRGBO(255, 255, 255, 1),
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal),
                      );
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
    final Brightness brightness =
        ThemeData.estimateBrightnessForColor(tile.color);
    final Color color =
        brightness == Brightness.dark ? Colors.white : Colors.black;
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
                fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              'Population : ' + tile.weight.toStringAsFixed(0) + ' B',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: Theme.of(context).textTheme.caption!.fontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescendantsLabels(TreemapTile tile) {
    final Brightness brightness =
        ThemeData.estimateBrightnessForColor(tile.color);
    final Color color =
        brightness == Brightness.dark ? Colors.white : Colors.black;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 4.0, right: 4),
        child: Text(
          tile.group,
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(fontSize: 11, color: color),
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
                style: Theme.of(context).textTheme.caption!.copyWith(
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
                style: Theme.of(context).textTheme.caption!.copyWith(
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: _isLightTheme
                          ? const Color.fromRGBO(255, 255, 255, 1)
                          : const Color.fromRGBO(10, 10, 10, 1),
                    ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\n' +
                        _worldPopulationDetails[tile.indices[0]]
                            .populationInCrores
                            .toStringAsFixed(0) +
                        ' B',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _WorldPopulationDetails {
  const _WorldPopulationDetails({
    required this.continent,
    required this.populationInCrores,
    this.country,
    this.state,
    this.color,
  });

  final String continent;
  final String? country;
  final String? state;
  final double populationInCrores;
  final Color? color;
}
