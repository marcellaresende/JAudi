class ClientBusinessRequest {
  final String name;
  final String cnpj;
  final String email;
  final String cellphone;



  ClientBusinessRequest({
    required this.name,
    required this.cnpj,
    required this.email,
    required this.cellphone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cnpj': cnpj,
      'email': email,
      'cellphone': cellphone,
    };
  }
}

class ClientBusinessResponse {
  final int id;
  final String name;
  final String cnpj;
  final String email;
  final String cellphone;
  final String creationDate;
  final int responsibleCentralId;

  ClientBusinessResponse({
    required this.id,
    required this.name,
    required this.cnpj,
    required this.email,
    required this.cellphone,
    required this.creationDate,
    required this.responsibleCentralId,
  });

  factory ClientBusinessResponse.fromJson(Map<String, dynamic> json) {
    return ClientBusinessResponse(
      id: json['id'],
      name: json['name'],
      cnpj: json['cnpj'],
      email: json['email'],
      cellphone: json['cellphone'],
      creationDate: json['creationDate'],
      responsibleCentralId: json['responsibleCentralId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cnpj': cnpj,
      'email': email,
      'cellphone': cellphone,
      'creationDate': creationDate,
      'responsibleCentralId': responsibleCentralId
    };
  }
}

