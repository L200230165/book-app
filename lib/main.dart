import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookListPage(),
    );
  }
}

// DATA BUKU
final List<Map<String, String>> books = [
  {"title": "Solo Leveling", "pdf": "assets/pdf/book1.pdf"},
  {"title": "Tomb Raider King", "pdf": "assets/pdf/book2.pdf"},
  {"title": "Return of the Blossoming Blade", "pdf": "assets/pdf/book3.pdf"},
  {"title": "Villains Are Destined to Die", "pdf": "assets/pdf/book4.pdf"},
  {"title": "Trash of the Count’s Family", "pdf": "assets/pdf/book5.pdf"},
  {"title": "The Remarried Empress", "pdf": "assets/pdf/book6.pdf"},
  {"title": "Who Made Me a Princess", "pdf": "assets/pdf/book7.pdf"},
  {"title": "I Am a Child of This House", "pdf": "assets/pdf/book8.pdf"},
  {"title": "Omniscient Reader’s Viewpoint", "pdf": "assets/pdf/book9.pdf"},
  {"title": "The Beginning After The End", "pdf": "assets/pdf/book10.pdf"},
];

// HALAMAN LIST
class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Novel → Webtoon"),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.menu_book),
              title: Text(books[index]["title"]!),
              subtitle: const Text("Novel → Webtoon"),
              trailing: ElevatedButton(
                child: const Text("Read the book"),
                onPressed: () async {
                  final path = await loadPdfFromAssets(
                    books[index]["pdf"]!,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewPage(
                        title: books[index]["title"]!,
                        pdfPath: path,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// FUNCTION LOAD PDF DARI ASSET
Future<String> loadPdfFromAssets(String path) async {
  final data = await rootBundle.load(path);
  final bytes = data.buffer.asUint8List();

  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/${path.split('/').last}");

  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

// HALAMAN PDF VIEWER
class PDFViewPage extends StatelessWidget {
  final String title;
  final String pdfPath;

  const PDFViewPage({
    super.key,
    required this.title,
    required this.pdfPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}