import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuoteService _quoteService = QuoteService();
  Quote? _quote;
  bool _isLoading = false;

  Future<void> _getQuote() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final newQuote = await _quoteService.fetchQuote();
      setState(() {
        _quote = newQuote;
      });
    } catch (e) {
      setState(() {
        _quote = Quote(content: 'Error fetching quote.', author: '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'InspireMe Quotes',
          style: GoogleFonts.aBeeZee(
            fontSize: 24,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_quote != null)
              Center(
                child: Card(
                  color: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '"${_quote!.content}"',
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '- ${_quote!.author}',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.pinkAccent,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: _getQuote,
              icon: const Icon(Icons.refresh),
              label: const Text('New Quote'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
