// class EarnRefer{
//   final int id;
//   final String name;
//   final String email;
//   final double earning;
//   final String phoneNumber;
//   final String dateTime;
//   EarnRefer(this.id, this.name, this.email,this.earning, this.phoneNumber, this.dateTime);
// }
class TransactionHistoryResponse {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final List<TransactionData> data;

  TransactionHistoryResponse(
      {required this.total, required this.perPage, required this.currentPage, required this.lastPage, required this.data,});
  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponse(
      total: json['total'] ?? 0,
      perPage: json['per_page'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      data: List<TransactionData>.from(
        (json['data'] ?? []).map((x) => TransactionData.fromJson(x)),
      ),
    );
  }

}
class TransactionData {
  final Transaction transaction;
  final Referrer? referrer;
  TransactionData({required this.transaction,required this.referrer});
  factory TransactionData.fromJson(Map<String, dynamic> json) {
    final ref = json['referrer'];
    final isReferrerEmpty = ref == null ||
        (ref['id'] == null &&
            ref['name'] == null &&
            ref['phone'] == null &&
            ref['email'] == null);

    return TransactionData(
      transaction: Transaction.fromJson(json['transaction']),
      referrer: isReferrerEmpty ? null : Referrer.fromJson(ref),
    );
  }
}
class Transaction {
  final String id;
  final int credit;
  final int balanceAfter;
  final String transactionDate;
Transaction({required this.id, required this.credit, required this.balanceAfter, required this.transactionDate});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      credit: json['credit'] ?? 0,
      balanceAfter: json['balance_after'] ?? 0,
      transactionDate: json['transaction_date'] ?? '',
    );
  }
}
class Referrer {
  final int? id;
  final String? name;
  final String? phone;
  final String? email;

  Referrer({
    this.id,
    this.name,
    this.phone,
    this.email,
  });
  factory Referrer.fromJson(Map<String, dynamic> json) {
    return Referrer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  /// Custom getter to return a default display name if name is null
  String get displayName => name ?? 'User has been deleted';
}