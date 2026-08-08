enum VerificationStatus { pending, approved, rejected }

VerificationStatus _statusFromString(String? value) {
  switch (value) {
    case 'approved':
      return VerificationStatus.approved;
    case 'rejected':
      return VerificationStatus.rejected;
    default:
      return VerificationStatus.pending;
  }
}

class CompanyModel {
  CompanyModel({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.verificationStatus,
    this.address,
    this.contactEmail,
    this.contactPhone,
    this.logoUrl,
  });

  final String id;
  final String name;
  final String registrationNumber;
  final VerificationStatus verificationStatus;
  final String? address;
  final String? contactEmail;
  final String? contactPhone;
  final String? logoUrl;

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json['id'] as String,
        name: json['name'] as String,
        registrationNumber: json['registration_number'] as String,
        verificationStatus: _statusFromString(json['verification_status'] as String?),
        address: json['address'] as String?,
        contactEmail: json['contact_email'] as String?,
        contactPhone: json['contact_phone'] as String?,
        logoUrl: json['logo_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'registration_number': registrationNumber,
        'address': address,
        'contact_email': contactEmail,
        'contact_phone': contactPhone,
      };
}
