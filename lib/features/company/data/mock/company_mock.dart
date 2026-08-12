import '../models/company_model.dart';

/// Demo data returned while `AppConfig.mockMode` is true. Mutable so a
/// registration/update within the session is reflected on the profile.
class CompanyMock {
  CompanyMock._();

  static CompanyModel company = CompanyModel(
    id: 'comp-001',
    name: 'BuildPro Constructions',
    type: CompanyType.privateLimited,
    yearEstablished: 2012,
    description: 'Multi-specialty civil contractor for residential and commercial projects.',
    gstin: '29ABCDE1234F1Z5',
    pan: 'ABCDE1234F',
    cin: 'U45200PB2012PTC000123',
    udyamRegistrationNumber: 'UDYAM-PB-11-0001234',
    labourLicenseNumber: 'LL-23-00421',
    pfEsicNumber: 'PB/PF/IND/123456',
    contactPersonName: 'Harpreet Singh',
    contactPersonDesignation: 'Managing Director',
    contactPhone: '+91 98765 43210',
    alternatePhone: '+91 91234 56780',
    contactEmail: 'admin@buildpro.in',
    website: 'www.buildpro.in',
    registeredAddress: const AddressModel(
      line1: '48 MG Road',
      line2: 'Civil Lines',
      city: 'Ludhiana',
      state: 'Punjab',
      pincode: '141001',
    ),
    specializations: ['Civil', 'Electrical', 'Plumbing'],
    areasOfOperation: ['Ludhiana', 'Chandigarh', 'Bathinda'],
    teamSizeRange: '50-100',
    verificationStatus: VerificationStatus.pending,
  );

  static CompanyModel save(CompanyModel updated, {VerificationStatus status = VerificationStatus.pending}) {
    company = CompanyModel(
      id: company.id,
      name: updated.name,
      type: updated.type,
      yearEstablished: updated.yearEstablished,
      logoUrl: updated.logoUrl,
      description: updated.description,
      gstin: updated.gstin,
      pan: updated.pan,
      cin: updated.cin,
      udyamRegistrationNumber: updated.udyamRegistrationNumber,
      labourLicenseNumber: updated.labourLicenseNumber,
      pfEsicNumber: updated.pfEsicNumber,
      contactPersonName: updated.contactPersonName,
      contactPersonDesignation: updated.contactPersonDesignation,
      contactPhone: updated.contactPhone,
      alternatePhone: updated.alternatePhone,
      contactEmail: updated.contactEmail,
      website: updated.website,
      registeredAddress: updated.registeredAddress,
      operationalAddress: updated.operationalAddress,
      specializations: updated.specializations,
      areasOfOperation: updated.areasOfOperation,
      teamSizeRange: updated.teamSizeRange,
      verificationStatus: status,
      documents: updated.documents,
    );
    return company;
  }
}