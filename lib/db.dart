import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthClientOptions;
// Untuk opsi auth

class SupabaseDB {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<void> init() async {
    try {
      await Supabase.initialize(
        url: 'https://mligcolwhmyfnihtcsva.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1saWdjb2x3aG15Zm5paHRjc3ZhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwNTMxNTcsImV4cCI6MjA2NDYyOTE1N30.1JBDRMY-vr5XV6NWu1OzGVMUEI47EBYfRIHPx7yiQNQ',
      );
    } catch (e) {
      print('Supabase init error: $e');
      rethrow;
    }
  }

  // Contoh CRUD Transaksi
  static Future<void> addTransaction(double amount, String currency) async {
    try {
      await client.from('transactions').insert({
        'user_id': client.auth.currentUser!.id,
        'amount': amount,
        'currency': currency,
      });
    } on PostgrestException catch (e) {
      print('Error adding transaction: ${e.message}');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    try {
      final res = await client
          .from('transactions')
          .select()
          .eq('user_id', client.auth.currentUser!.id);
      return res;
    } on PostgrestException catch (e) {
      print('Error fetching transactions: ${e.message}');
      return [];
    }
  }

    // Contoh CRUD Transaksi
  static Future<void> addItem(String title) async {
    await client
        .from('todos')
        .insert({'title': title, 'user_id': client.auth.currentUser!.id});
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final response = await client
        .from('todos')
        .select()
        .eq('user_id', client.auth.currentUser!.id);
    return response;
  }

  static Future<void> updateItem(int id, String newTitle) async {
    await client.from('todos').update({'title': newTitle}).eq('id', id);
  }

  static Future<void> deleteItem(int id) async {
    await client.from('todos').delete().eq('id', id);
  }

  //fungsi search
  static Future<List<Map<String, dynamic>>> searchTransactions(String keyword) async {
    try {
      final res = await client
          .from('transactions')
          .select()
          .ilike('description', '%$keyword%') // Cari di kolom description
          .eq('user_id', client.auth.currentUser!.id);
      return res;
    } on PostgrestException catch (e) {
      print('Search error: ${e.message}');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> searchItems(String keyword) async {
    try {
      final res = await client
          .from('todos')
          .select()
          .ilike('title', '%$keyword%') // Cari di kolom title
          .eq('user_id', client.auth.currentUser!.id);
      return res;
    } on PostgrestException catch (e) {
      print('Search error: ${e.message}');
      return [];
    }
  }
}