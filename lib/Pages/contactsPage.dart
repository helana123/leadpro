import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:leadconnectpro/Widgets/widgets.dart';

class ContactsPage extends StatelessWidget {
  final String extractedText;

  ContactsPage({required this.extractedText});

  @override
  Widget build(BuildContext context) {
    // Parse extracted text to identify fields
    Contact contact = _parseExtractedText(extractedText);

    // Save the contact
    _saveContact(contact);

    // Create a list of label-text pairs for each recognized field
    List<Map<String, String?>> extractedFields = [
      {'label': 'Name', 'text': contact.displayName ?? ''},
      {'label': 'Email', 'text': contact.emails?.isNotEmpty == true ? contact.emails!.first.value : ''},
      {'label': 'Phone Number', 'text': contact.phones?.isNotEmpty == true ? contact.phones!.first.value : ''},
      {'label': 'Job Title', 'text': contact.jobTitle ?? ''},
      {'label': 'Company', 'text': contact.company ?? ''},
      {'label': 'Address', 'text': contact.postalAddresses?.isNotEmpty == true ? contact.postalAddresses!.first.street : ''},
    ];

    return Scaffold(
      appBar: MyAppBar(
        title: 'Contact Details',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: extractedFields.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    extractedFields[index]['label']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: TextEditingController(text: extractedFields[index]['text']!),
                    maxLines: extractedFields[index]['label'] == 'Address' ? 3 : 1,
                    minLines: extractedFields[index]['label'] == 'Address' ? 2 : 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: 'Not found',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }


  // Parse extracted text to create a Contact object
  Contact _parseExtractedText(String extractedText) {
    Contact contact = Contact();

    List<String> lines = extractedText.split('\n');

    for (String line in lines) {
      // Check for name
      if (contact.displayName == null && _isLikelyName(line)) {
        contact.displayName = line.trim();
      }
      // Check for email
      else if (contact.emails?.isEmpty ?? true && _isEmail(line)) {
        contact.emails = [Item(label: 'email', value: line.trim())];
      }
      // Check for phone number
      else if (contact.phones?.isEmpty ?? true && _isPhoneNumber(line)) {
        contact.phones = [Item(label: 'phone', value: line.trim())];
      }
      // Check for job title
      else if (contact.jobTitle == null && _isLikelyJobTitle(line, contact.displayName ?? '')) {
        contact.jobTitle = line.trim();
      }
      // Check for company
      else if (contact.company == null && _isLikelyCompany(line)) {
        contact.company = line.trim();
      }
      // Check for address
      else if (contact.postalAddresses?.isEmpty ?? true && _isLikelyAddress(line)) {
        contact.postalAddresses = [
          PostalAddress(
            label: 'address',
            street: line.trim(),
          )
        ];
      }
    }

    return contact;
  }


  // Helper methods to check patterns
  bool _isLikelyName(String line) {
    return line.trim().contains(RegExp(r'[a-zA-Z ]'));
  }

  bool _isEmail(String line) {
    return line.trim().contains('@');
  }

  bool _isPhoneNumber(String line) {
    return line.trim().contains(RegExp(
        r'(\+\d{1,3}\s?)?' // Country code (optional, 1-3 digits)
        r'(\d{3}[\s.-]?)?' // Area code (optional, 3 digits)
        r'(\d{3}[\s.-]?)?' // Prefix (optional, 3 digits)
        r'\d{4}' // Line number (required, 4 digits)
    ),
    );
  }

  bool _isLikelyJobTitle(String text, String name) {
    List<String> lines = text.split('\n'); // Split text into lines
    int nameIndex = lines.indexWhere((line) => line.toLowerCase().contains(name.toLowerCase()));
    if (nameIndex != -1 && nameIndex < lines.length - 1) {
      // Check if the line below the name contains a likely job title
      String nextLine = lines[nameIndex + 1].trim();
      return nextLine.isNotEmpty && !nextLine.contains(RegExp(r'[.,:;]'));
    }
    return false;
  }

  bool _isLikelyCompany(String line) {
    return line.toLowerCase().contains(RegExp(r'company', caseSensitive: false));
  }

  bool _isLikelyAddress(String line) {
    return line.toLowerCase().contains(RegExp(
        r'(?:[^\n,]+(?:,\s*[^\n,]+)*)?' // Multiline address (optional)
    ),
    );
  }

  // Save contact
  Future<void> _saveContact(Contact contact) async {
    try {
      await ContactsService.addContact(contact);
    } catch (e) {
      // Handle error
    }
  }
}