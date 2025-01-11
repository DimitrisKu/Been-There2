import 'package:flutter/material.dart';
import 'AppBars.dart';
import 'Menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Η οθόνη για τη δημιουργία νέου post
class NewPost_Widget extends StatefulWidget {
  @override
  _NewPost_WidgetState createState() => _NewPost_WidgetState();
}

class _NewPost_WidgetState extends State<NewPost_Widget> {
  // Δημιουργία ενός ImagePicker για να πάρουμε τις εικόνες
  final ImagePicker _picker = ImagePicker();
  XFile? _image; // Η εικόνα που θα επιλεγεί
  int _rating =
      0; // Αρχική βαθμολογία (0 σημαίνει ότι δεν έχει επιλεγεί τίποτα)

  // Συνάρτηση για να επιλέξουμε εικόνα από την συλλογή φωτογραφιών ή την κάμερα
  Future<void> _pickImage() async {
    // Εμφανίζει επιλογές για κάμερα ή φωτογραφίες
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = pickedImage; // Αν επιλέχθηκε εικόνα, την αποθηκεύουμε
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Παίρνουμε το όνομα χρήστη που περνιέται ως argument
    final String user = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: saveAppBar(context, user), // Χρησιμοποιούμε custom app bar
      backgroundColor: const Color(0xFFF5F5F5), // Ανοιχτό γκρι φόντο
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0), // Περιθώριο
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24), // Κενό διάστημα από την κορυφή
              Text(
                'Recommend a place\nanywhere in the world!',
                textAlign: TextAlign.center,
                style: GoogleFonts.abhayaLibre(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Πεδίο αναζήτησης τοποθεσίας
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search places or businesses',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Πεδίο για tag φίλων
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_add_alt),
                  hintText: 'Tag a friend',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Κουμπί για προσθήκη φωτογραφιών
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.photo),
                      SizedBox(width: 8),
                      Text('Add your photos'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Εμφάνιση επιλεγμένης εικόνας
              if (_image != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(File(_image!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Πεδίο για περιγραφή
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Βαθμολόγηση τοποθεσίας
              Text(
                'Your final rate for this location:',
                textAlign: TextAlign.center,
                style: GoogleFonts.abhayaLibre(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      _rating > index ? Icons.star : Icons.star_border,
                      color: const Color(0xFF1A2642),
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
