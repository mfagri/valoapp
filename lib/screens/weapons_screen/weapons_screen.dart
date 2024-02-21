// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:valorant/services/api.dart';

import '../weapons_details_skins_screen/weapons_main_screen.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:valorant/models/weapon/weapon.dart';
import 'package:flutter/material.dart';
import '../../services/weapon_api.dart';

class WeaponsScreen extends StatefulWidget {
  Ads api;
  WeaponsScreen({super.key, required this.api});

  @override
  State<WeaponsScreen> createState() => _WeaponsScreenState();
}

class _WeaponsScreenState extends State<WeaponsScreen> {
  List<Weapon>? weapons = [];

  @override
  void initState() {
    fetchWeapons();
    super.initState();
  }

  Future<void> fetchWeapons() async {
    final response = await WeaponApi.fetchWeapons();
    setState(() {
      weapons = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weapons",
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: (weapons!.length != 0)
            ? Column(
                children: [
                  ...List.generate(
                    weapons!.length,
                    (index) {
                      final weapon = weapons![index];
                      return GestureDetector(
                        onTap: () async {
                          if (widget.api.istate == 1) {
                            await Adsapi.nitInterstitialAd(
                                    widget.api.interstitial!)
                                .whenComplete(() {
                              Adsapi.interstitalAd?.show();
                            });
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeaponsMainScreen(
                                weapon: weapon,
                                api: widget.api,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                                height: 200,
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      isDarkMode
                                          ? const Color(0xFF343434)
                                          : const Color(0xCCD4CDCD),
                                      isDarkMode
                                          ? const Color(0xFF565353)
                                          : const Color(0xFFFFFFFF),
                                    ],
                                    stops: const [0.4, 0.6],
                                  ),
                                ),
                                child: Hero(
                                  tag: weapon.uuid!,
                                  //child: CachedNetworkImage(
                                  // key: UniqueKey(),
                                  //imageUrl: weapon.displayIcon!,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                    weapon.displayIcon!,
                                  )))),
                                )),
                            Positioned(
                              left: 40,
                              bottom: 30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    weapon.displayName!,
                                    style: TextStyle(
                                      fontFamily: "Valorant",
                                      fontSize: 28,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
            : const Center(
                child: SizedBox(
                    height: 80,
                    width: 80,
                    child: Center(child: CircularProgressIndicator())),
              ),
      ),
    );
  }
}
