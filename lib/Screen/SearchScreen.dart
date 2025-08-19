import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String query = "";
  String specialityFilter = "All";
  double ratingFilter = 0;

  final List<Map<String, dynamic>> recentSearches = [
    {"text": "Dr. Ali"},
    {"text": "Dentist"},
  ];

  final List<Map<String, dynamic>> doctors = [

  ];

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Sort By",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Speciality",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      "All",
                      "General",
                      "Neurologic",
                      "Pediatric",
                      "Radiology",
                      "ENT",
                      "Dentistry",
                      "Optometry",
                      "Intestine",
                      "Urologist",
                      "Hepatology",
                      "Histologist",
                      "Cardiologist",
                      "Pulmonary"
                    ].map((spec) {
                      return ChoiceChip(
                        label: Text(spec),
                        selected: specialityFilter == spec,
                        onSelected: (_) {
                          setModalState(() {
                            specialityFilter = spec;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Rating",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    children: [0, 5, 4, 3].map((rate) {
                      return ChoiceChip(
                        label: rate == 0 ? const Text("All") : Text("$rate ★"),
                        selected: ratingFilter == rate.toDouble(),
                        onSelected: (_) {
                          setModalState(() {
                            ratingFilter = rate.toDouble();
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 50)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          decoration: TextDecoration.none, // يزيل الخط الأصفر
                        ),
                      ),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      overlayColor:
                      MaterialStateProperty.all(Colors.blueAccent),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    child: const Text("Done"),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredDoctors = doctors.where((doc) {
      final matchesQuery =
          query.isEmpty || doc["name"].toLowerCase().contains(query.toLowerCase());
      final matchesSpeciality =
          specialityFilter == "All" || doc["speciality"] == specialityFilter;
      final matchesRating = ratingFilter == 0 || doc["rating"] >= ratingFilter;
      return matchesQuery && matchesSpeciality && matchesRating;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Search", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        query = val;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _openFilterSheet,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.filter_list),
                  ),
                ),
              ],
            ),
          ),
          if (query.isEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child:
                    Text("Recent Search", style: TextStyle(fontSize: 16)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: recentSearches.length,
                      itemBuilder: (context, index) {
                        final item = recentSearches[index];
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(item["text"]),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                recentSearches.removeAt(index);
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              query = item["text"];
                              _searchController.text = query;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doc = filteredDoctors[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(doc["image"]),
                      radius: 30,
                    ),
                    title: Text(doc["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      children: [
                        Text("${doc["speciality"]} | ${doc["hospital"]}"),
                        const SizedBox(width: 5),
                        Icon(Icons.star, color: Colors.yellow[700], size: 18),
                        Text(" ${doc["rating"]}")
                      ],
                    ),
                    onTap: () {},
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.search),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
