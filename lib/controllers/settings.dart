import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:productivity_app/database/finance_db.dart';
import 'package:productivity_app/models/categories.dart';
import 'package:productivity_app/models/category.dart';
import 'package:productivity_app/models/user.dart';
import 'package:productivity_app/views/widgets/profile_picture.dart';
import 'package:productivity_app/views/widgets/username.dart';
import 'package:productivity_app/controllers/username_form.dart';

import 'changed_profile.dart';

class Settings extends StatefulWidget {
  final VoidCallback refreshed;

  const Settings({super.key, required this.refreshed});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void refresh() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                children: [
                  ProfilePicture(key: UniqueKey(),),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.shade200,
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/svg/camera.svg',
                            width: 40,
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return ChangeProfile(changed_profile: widget.refreshed, refreshed: refresh,);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text('Username: ',style: TextStyle(fontSize: 32),),
                  Username(key: UniqueKey(),),
                ],
              ),
              const SizedBox(
                width: 16,
              ),
              InkWell(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/svg/pencil.svg',
                      width: 30,
                    ),
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: (context),
                    builder: (context) => UsernameForm(onUsernameChanged: widget.refreshed, refreshed: refresh,)
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Divider(
            height: 4,
            thickness: 4,
            color: Colors.blue.shade500,
          ),
          const SizedBox(
            height: 32,
          ),
          const CurrencyDropdown()
        ],
      ),
    );
  }
}

class CurrencyDropdown extends StatefulWidget {
  const CurrencyDropdown({super.key});

  @override
  State<CurrencyDropdown> createState() => _CurrencyDropdownState();
}

class _CurrencyDropdownState extends State<CurrencyDropdown> {
  User? user;
  dynamic _selectedCategory;
  final db = FinanceDB();

  @override
  void initState() {
    super.initState();
    _categoryValue();
  }

  void _saveCurrency() async {
    await db.updateCurrency(_selectedCategory.symbol);
  }

  void _categoryValue() async {
    user = await db.fetchUser();
    if (user != null) {
      for (var entry in currency_categories.entries) {
        if (entry.value.symbol == user!.currency) {
          setState(() {
            _selectedCategory = entry.value;
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropdownButtonFormField<CurrencyCategory>(
        value: _selectedCategory,
        items: currency_categories.entries.map((entry) {
          return DropdownMenuItem<CurrencyCategory>(
            value: entry.value,
            child: Row(
              children: [
                Text(entry.value.symbol),
                const SizedBox(width: 8),
                Text(entry.value.title),
                const SizedBox(width: 8),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value!;
          });
          _saveCurrency();
        },
      ),
    );
  }
}



