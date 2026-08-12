enum VerificationStatus { pending, approved, rejected }

enum CompanyType { proprietorship, partnership, privateLimited, llp, individual }

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

CompanyType _typeFromString(String? value) {
  switch (value) {
    case 'partnership':
      return CompanyType.partnership;
    case 'private_limited':
      return CompanyType.privateLimited;
    case 'llp':
      return CompanyType.llp;
    case 'individual':
      return CompanyType.individual;
    default:
      return CompanyType.proprietorship;
  }
}

String _typeToString(CompanyType type) {
  switch (type) {
    case CompanyType.proprietorship:
      return 'proprietorship';
    case CompanyType.partnership:
      return 'partnership';
    case CompanyType.privateLimited:
      return 'private_limited';
    case CompanyType.llp:
      return 'llp';
    case CompanyType.individual:
      return 'individual';
  }
}

String companyTypeLabel(CompanyType type) {
  switch (type) {
    case CompanyType.proprietorship:
      return 'Proprietorship';
    case CompanyType.partnership:
      return 'Partnership';
    case CompanyType.privateLimited:
      return 'Private Limited';
    case CompanyType.llp:
      return 'LLP';
    case CompanyType.individual:
      return 'Individual';
  }
}

/// Registered/operational address — used for both company address fields.
class AddressModel {
  const AddressModel({
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.pincode,
  });

  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String pincode;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        line1: json['line1'] as String,
        line2: json['line2'] as String?,
        city: json['city'] as String,
        state: json['state'] as String,
        pincode: json['pincode'] as String,
      );

  Map<String, dynamic> toJson() => {
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'pincode': pincode,
      };
}

/// Verification documents uploaded for the Company Verification flow.
/// Each field stores the uploaded file's URL once uploaded (null = not
/// uploaded yet). Actual file upload is a separate multipart call —
/// this model just tracks what's on file.
class CompanyDocumentsModel {
  const CompanyDocumentsModel({
    this.gstCertificateUrl,
    this.panCardUrl,
    this.registrationCertificateUrl,
    this.addressProofUrl,
    this.authorizedSignatoryIdUrl,
  });

  final String? gstCertificateUrl;
  final String? panCardUrl;
  final String? registrationCertificateUrl;
  final String? addressProofUrl;
  final String? authorizedSignatoryIdUrl;

  factory CompanyDocumentsModel.fromJson(Map<String, dynamic> json) =>
      CompanyDocumentsModel(
        gstCertificateUrl: json['gst_certificate_url'] as String?,
        panCardUrl: json['pan_card_url'] as String?,
        registrationCertificateUrl: json['registration_certificate_url'] as String?,
        addressProofUrl: json['address_proof_url'] as String?,
        authorizedSignatoryIdUrl: json['authorized_signatory_id_url'] as String?,
      );

  bool get isComplete =>
      gstCertificateUrl != null &&
      panCardUrl != null &&
      registrationCertificateUrl != null &&
      addressProofUrl != null &&
      authorizedSignatoryIdUrl != null;
}

class CompanyModel {
  const CompanyModel({
    required this.id,
    // ---- 1. Basic details ----
    required this.name,
    required this.type,
    this.yearEstablished,
    this.logoUrl,
    this.description,
    // ---- 2. Registration & legal ----
    required this.gstin,
    required this.pan,
    this.cin,
    this.udyamRegistrationNumber,
    this.labourLicenseNumber,
    this.pfEsicNumber,
    // ---- 3. Contact details ----
    required this.contactPersonName,
    required this.contactPersonDesignation,
    required this.contactPhone,
    this.alternatePhone,
    required this.contactEmail,
    this.website,
    // ---- 4. Address ----
    required this.registeredAddress,
    this.operationalAddress, // null = same as registered
    // ---- 6. Business scope ----
    required this.specializations,
    required this.areasOfOperation,
    this.teamSizeRange,
    // ---- 7. Verification ----
    required this.verificationStatus,
    this.documents = const CompanyDocumentsModel(),
  });

  final String id;

  // 1. Basic details
  final String name;
  final CompanyType type;
  final int? yearEstablished;
  final String? logoUrl;
  final String? description;

  // 2. Registration & legal
  final String gstin;
  final String pan;
  final String? cin;
  final String? udyamRegistrationNumber;
  final String? labourLicenseNumber;
  final String? pfEsicNumber;

  // 3. Contact details
  final String contactPersonName;
  final String contactPersonDesignation;
  final String contactPhone;
  final String? alternatePhone;
  final String contactEmail;
  final String? website;

  // 4. Address
  final AddressModel registeredAddress;
  final AddressModel? operationalAddress;

  // 6. Business scope
  final List<String> specializations; // e.g. ['Civil', 'Electrical', 'Plumbing']
  final List<String> areasOfOperation; // e.g. ['Bathinda', 'Chandigarh']
  final String? teamSizeRange; // e.g. '1-10', '10-50', '50+'

  // 7. Verification
  final VerificationStatus verificationStatus;
  final CompanyDocumentsModel documents;

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json['id'] as String,
        name: json['name'] as String,
        type: _typeFromString(json['type'] as String?),
        yearEstablished: json['year_established'] as int?,
        logoUrl: json['logo_url'] as String?,
        description: json['description'] as String?,
        gstin: json['gstin'] as String,
        pan: json['pan'] as String,
        cin: json['cin'] as String?,
        udyamRegistrationNumber: json['udyam_registration_number'] as String?,
        labourLicenseNumber: json['labour_license_number'] as String?,
        pfEsicNumber: json['pf_esic_number'] as String?,
        contactPersonName: json['contact_person_name'] as String,
        contactPersonDesignation: json['contact_person_designation'] as String,
        contactPhone: json['contact_phone'] as String,
        alternatePhone: json['alternate_phone'] as String?,
        contactEmail: json['contact_email'] as String,
        website: json['website'] as String?,
        registeredAddress:
            AddressModel.fromJson(json['registered_address'] as Map<String, dynamic>),
        operationalAddress: json['operational_address'] != null
            ? AddressModel.fromJson(json['operational_address'] as Map<String, dynamic>)
            : null,
        specializations: (json['specializations'] as List? ?? [])
            .map((e) => e.toString())
            .toList(),
        areasOfOperation: (json['areas_of_operation'] as List? ?? [])
            .map((e) => e.toString())
            .toList(),
        teamSizeRange: json['team_size_range'] as String?,
        verificationStatus: _statusFromString(json['verification_status'] as String?),
        documents: json['documents'] != null
            ? CompanyDocumentsModel.fromJson(json['documents'] as Map<String, dynamic>)
            : const CompanyDocumentsModel(),
      );

  /// Used for the registration POST body. Verification status/documents
  /// aren't sent here — they're set by the backend / a separate upload flow.
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': _typeToString(type),
        'year_established': yearEstablished,
        'description': description,
        'gstin': gstin,
        'pan': pan,
        'cin': cin,
        'udyam_registration_number': udyamRegistrationNumber,
        'labour_license_number': labourLicenseNumber,
        'pf_esic_number': pfEsicNumber,
        'contact_person_name': contactPersonName,
        'contact_person_designation': contactPersonDesignation,
        'contact_phone': contactPhone,
        'alternate_phone': alternatePhone,
        'contact_email': contactEmail,
        'website': website,
        'registered_address': registeredAddress.toJson(),
        'operational_address': operationalAddress?.toJson(),
        'specializations': specializations,
        'areas_of_operation': areasOfOperation,
        'team_size_range': teamSizeRange,
      };
}