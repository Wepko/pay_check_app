import 'dart:convert';

class Receipt {
  int? id;
  final String organizationName;
  final double totalAmount;
  final DateTime date;
  final String? organizationAddress;
  final String? receiptNumber;
  final List<ReceiptItem>? items;
  final bool? isTaxable;
  final String? cashierName;
  final PaymentType? paymentType;
  final String? legalEntityName;
  final String? fiscalNumber;
  final String? fiscalDocument;
  final String? fiscalSign;
  final String? kktRegistrationNumber;
  final String? kktFactoryNumber;

  Receipt({
    this.id,
    required this.organizationName,
    required this.totalAmount,
    required this.date,
    this.organizationAddress,
    this.receiptNumber,
    this.items,
    this.isTaxable,
    this.cashierName,
    this.paymentType,
    this.legalEntityName,
    this.fiscalNumber,
    this.fiscalDocument,
    this.fiscalSign,
    this.kktRegistrationNumber,
    this.kktFactoryNumber,
  });

  Map<String, dynamic> toMap() {
    const isTaxable = false;
    //const items = [];

    return {
      'id': id,
      'organization_name': organizationName,
      'organization_address': organizationAddress,
      'receipt_number': receiptNumber,
      'date': date.millisecondsSinceEpoch,
      'items': json.encode(items?.map((item) => item.toMap()).toList() ?? []),
      'total_amount': totalAmount,
      'is_taxable': isTaxable ? 1 : 0,
      'cashier_name': cashierName,
      'payment_type': paymentType?.index, // Сохраняем как ЧИСЛО (int)
      'legal_entity_name': legalEntityName,
      'fiscal_number': fiscalNumber,
      'fiscal_document': fiscalDocument,
      'fiscal_sign': fiscalSign,
      'kkt_registration_number': kktRegistrationNumber,
      'kkt_factory_number': kktFactoryNumber,
    };
  }

  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      id: map['id'],
      organizationName: map['organization_name'],
      organizationAddress: map['organization_address'],
      receiptNumber: map['receipt_number'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      items: List<ReceiptItem>.from(
        json.decode(map['items']).map((x) => ReceiptItem.fromMap(x)),
      ),
      totalAmount: map['total_amount'],
      isTaxable: map['is_taxable'] == 1,
      cashierName: map['cashier_name'],
      paymentType: map['payment_type'] != null
          ? PaymentType.values[map['payment_type']] // Получаем как ЧИСЛО
          : null,
      legalEntityName: map['legal_entity_name'],
      fiscalNumber: map['fiscal_number'],
      fiscalDocument: map['fiscal_document'],
      fiscalSign: map['fiscal_sign'],
      kktRegistrationNumber: map['kkt_registration_number'],
      kktFactoryNumber: map['kkt_factory_number'],
    );
  }
}

class ReceiptItem {
  final String name;
  final double weight;
  final double? discount;
  final double price;
  final int quantity;
  final double total;

  ReceiptItem({
    required this.name,
    required this.weight,
    this.discount,
    required this.price,
    required this.quantity,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'weight': weight,
      'discount': discount,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }

  factory ReceiptItem.fromMap(Map<String, dynamic> map) {
    return ReceiptItem(
      name: map['name'],
      weight: map['weight'],
      discount: map['discount'],
      price: map['price'],
      quantity: map['quantity'],
      total: map['total'],
    );
  }
}

enum PaymentType { cash, cashless }
