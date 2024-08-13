class ClientBusinessRequest {
  final String name;
  final String cnpj;
  final String cellphone;



  ClientBusinessRequest({
    required this.name,
    required this.cnpj,
    required this.cellphone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cnpj': cnpj,
      'cellphone': cellphone,
    };
  }
}

class ClientBusinessResponse {
  final int id;
  final String name;
  final String cnpj;
  final String cellphone;
  final String creationDate;
  final int responsibleCentral;

  ClientBusinessResponse({
    required this.id,
    required this.name,
    required this.cnpj,
    required this.cellphone,
    required this.creationDate,
    required this.responsibleCentral,
  });

  factory ClientBusinessResponse.fromJson(Map<String, dynamic> json) {
    return ClientBusinessResponse(
      id: json['id'],
      name: json['name'],
      cnpj: json['cnpj'],
      cellphone: json['cellphone'],
      creationDate: json['creationDate'],
      responsibleCentral: json['responsibleCentral'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cnpj': cnpj,
      'cellphone': cellphone,
      'creationDate': creationDate,
      'responsibleCentral': responsibleCentral
    };
  }
}

