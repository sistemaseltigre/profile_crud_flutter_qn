class Token {
  int? decimals;
  double? balance;
  String? name;
  String? uri;
  String? symbol;
  String? tokenAddress;

  Token(
      {this.decimals,
      this.balance,
      this.name,
      this.uri,
      this.symbol,
      this.tokenAddress});

  Token.fromJson(Map<String, dynamic> json) {
    decimals = json['decimals'];
    balance = json['balance'];
    name = json['name'];
    uri = json['uri'];
    symbol = json['symbol'];
    tokenAddress = json['tokenAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['decimals'] = this.decimals;
    data['balance'] = this.balance;
    data['name'] = this.name;

    data['uri'] = this.uri;
    data['symbol'] = this.symbol;
    data['tokenAddress'] = this.tokenAddress;
    return data;
  }
}
