class RegulatoryTask {
  final String id;
  final String title;
  final String description;
  final List<String> resources;
  final List<String> dependsOn;
  bool isCompleted;

  RegulatoryTask({
    required this.id,
    required this.title,
    required this.description,
    this.resources = const [],
    this.dependsOn = const [],
    this.isCompleted = false,
  });

  bool canAccess(List<RegulatoryTask> allTasks) {
    // If no dependencies, the task is always accessible
    if (dependsOn.isEmpty) return true;
    
    // Check if all dependent tasks are completed
    return dependsOn.every((depId) => 
      allTasks.firstWhere((task) => task.id == depId).isCompleted
    );
  }
}

// Predefined list of regulatory milestones
List<RegulatoryTask> getDefaultRegulatoryMilestones() {
  return [
    // 1. Device Classification and Regulatory Strategy
    RegulatoryTask(
      id: '1.1',
      title: 'Determine Device Classification',
      description: 'Identify whether your device is Class I, II, or III based on risk level and intended use',
      resources: [
        'https://www.fda.gov/medical-devices/classify-your-medical-device/product-code-classification-database',
        'https://www.fda.gov/medical-devices/overview-device-regulation/classify-your-medical-device',
      ],
    ),
    RegulatoryTask(
      id: '1.2',
      title: 'Identify Product Code',
      description: 'Search FDA database to find the appropriate product code and regulation number for your device',
      resources: [
        'https://www.fda.gov/medical-devices/classify-your-medical-device/product-code-classification-database',
        'https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfPCD/classification.cfm',
      ],
      dependsOn: ['1.1'],
    ),
    RegulatoryTask(
      id: '1.3',
      title: 'Select Regulatory Pathway',
      description: 'Determine appropriate pathway (510(k), De Novo, PMA, or Exempt) based on device classification',
      resources: [
        'https://www.fda.gov/medical-devices/premarket-submissions/premarket-notification-510k',
  'https://www.fda.gov/medical-devices/premarket-submissions/de-novo-classification-request',
  'https://www.fda.gov/medical-devices/premarket-submissions/premarket-approval-pma',
      ],
      dependsOn: ['1.2'],
    ),
    
    // 2. Preclinical Testing and Design Controls
    RegulatoryTask(
      id: '2.1',
      title: 'Establish Design History File',
      description: 'Create documentation that demonstrates design controls were followed throughout development',
      resources: [
        'https://www.fda.gov/media/116573/download', // (Design Controls Guidance PDF)
  'https://www.fda.gov/medical-devices/quality-system-qs-regulationmedical-device-good-manufacturing-practices/design-controls',
      ],
      dependsOn: ['1.3'],
    ),
    RegulatoryTask(
      id: '2.2',
      title: 'Conduct Risk Analysis',
      description: 'Perform risk management according to ISO 14971, identifying hazards and mitigation strategies',
      resources: [
        'https://www.fda.gov/media/163915/download',
  'https://www.fda.gov/regulatory-information/search-fda-guidance-documents/factors-consider-regarding-benefit-risk-medical-device-product-availability-compliance-and',
      ],
      dependsOn: ['2.1'],
    ),
    RegulatoryTask(
      id: '2.3',
      title: 'Complete Bench Testing',
      description: 'Perform appropriate performance testing and document protocols and results',
      resources: [
        'https://www.fda.gov/medical-devices/device-advice-comprehensive-regulatory-assistance/overview-device-regulation',
        'https://www.fda.gov/regulatory-information/search-fda-guidance-documents/testing-and-labeling-medical-devices-safety-magnetic-resonance-mr-environment',
      ],
      dependsOn: ['2.2'],
    ),
    
    // 3. Clinical Evaluation
    RegulatoryTask(
      id: '3.1',
      title: 'Determine Clinical Data Needs',
      description: 'Assess whether clinical trials are required based on device class and risk',
      resources: [
        'https://www.fda.gov/medical-devices/investigational-device-exemption-ide/ide-approval-process',
        'https://www.fda.gov/regulatory-information/search-fda-guidance-documents/design-considerations-pivotal-clinical-investigations-medical-devices',
      ],
      dependsOn: ['2.3'],
    ),
    RegulatoryTask(
      id: '3.2',
      title: 'Prepare IDE Submission',
      description: 'If needed, prepare Investigational Device Exemption submission for clinical studies',
      resources: [
        'https://www.fda.gov/medical-devices/device-advice-investigational-device-exemption-ide/investigational-device-exemption-ide-basics',
        'https://www.fda.gov/medical-devices/investigational-device-exemption-ide/ide-application',
      ],
      dependsOn: ['3.1'],
    ),
    RegulatoryTask(
      id: '3.3',
      title: 'Create Clinical Protocol',
      description: 'Develop clinical study protocol including endpoints, inclusion/exclusion criteria, and IRB approval',
      resources: [
        'https://www.fda.gov/medical-devices/premarket-submissions-selecting-and-preparing-correct-submission/investigational-device-exemption-ide',
        'https://www.fda.gov/regulatory-information/search-fda-guidance-documents/informed-consent',
      ],
      dependsOn: ['3.2'],
    ),
    
    // 4. Quality System Implementation
    RegulatoryTask(
      id: '4.1',
      title: 'Establish QMS Structure',
      description: 'Set up Quality Management System per 21 CFR Part 820 and/or ISO 13485',
      resources: [
        'https://www.fda.gov/medical-devices/quality-system-qs-regulationmedical-device-good-manufacturing-practices/quality-system-regulation-21-cfr-part-820',
        'https://www.fda.gov/medical-devices/postmarket-requirements-devices/quality-system-qs-regulationmedical-device-good-manufacturing-practices',
      ],
      dependsOn: ['2.3'],
    ),
    RegulatoryTask(
      id: '4.2',
      title: 'Implement CAPA System',
      description: 'Create Corrective and Preventive Action procedures for addressing quality issues',
      resources: [
        'https://www.fda.gov/medical-devices/postmarket-requirements-devices/quality-system-qs-regulationmedical-device-current-good-manufacturing-practices-cgmp',
        'https://www.fda.gov/inspections-compliance-enforcement-and-criminal-investigations/inspection-guides/guide-inspections-quality-systems-696',
      ],
      dependsOn: ['4.1'],
    ),
    RegulatoryTask(
      id: '4.3',
      title: 'Establish Supplier Controls',
      description: 'Develop procedures for qualifying and monitoring suppliers and contractors',
      resources: [
        'https://www.fda.gov/medical-devices/postmarket-requirements-devices/quality-system-qs-regulationmedical-device-current-good-manufacturing-practices-cgmp',
        'https://www.fda.gov/media/94074/download',
      ],
      dependsOn: ['4.2'],
    ),
    
    // 5. Premarket Submission
    RegulatoryTask(
      id: '5.1',
      title: 'Prepare Submission Documents',
      description: 'Compile required documentation for 510(k), De Novo, or PMA submission',
      resources: [
        'https://www.fda.gov/medical-devices/premarket-submissions/premarket-notification-510k',
        'https://www.fda.gov/medical-devices/premarket-submissions/de-novo-classification-request',
        'https://www.fda.gov/medical-devices/premarket-submissions/premarket-approval-pma',
      ],
      dependsOn: ['3.3', '4.3'],
    ),
    RegulatoryTask(
      id: '5.2',
      title: 'Develop Device Labeling',
      description: 'Prepare compliant labeling, instructions for use, and unique device identification',
      resources: [
        'https://www.fda.gov/medical-devices/device-labeling/general-device-labeling-requirements',
        'https://www.fda.gov/medical-devices/device-advice-comprehensive-regulatory-assistance/unique-device-identification-udi-system',
      ],
      dependsOn: ['5.1'],
    ),
    RegulatoryTask(
      id: '5.3',
      title: 'Submit Application to FDA',
      description: 'Complete electronic submission through FDA\'s Electronic Submissions Gateway',
      resources: [
        'https://www.fda.gov/industry/electronic-submissions-gateway',
        'https://www.fda.gov/regulatory-information/search-fda-guidance-documents/acceptance-and-filing-reviews-premarket-approval-applications-pmas',
      ],
      dependsOn: ['5.2'],
    ),
    
    // 6. FDA Review and Communication
    RegulatoryTask(
      id: '6.1',
      title: 'Track FDA Review Status',
      description: 'Monitor submission status through FDA tracking systems',
      resources: [
        'https://www.fda.gov/medical-devices/premarket-submissions/additional-information-requests',
        'https://www.fda.gov/medical-devices/how-track-fda-medical-device-premarket-review-submission-process',
      ],
      dependsOn: ['5.3'],
    ),
    RegulatoryTask(
      id: '6.2',
      title: 'Respond to FDA Queries',
      description: 'Address additional information requests or deficiencies identified by FDA reviewers',
      resources: [
        'https://www.ecfr.gov/current/title-21/chapter-I/subchapter-H/part-807/subpart-E/section-807.87',
        'https://www.fda.gov/medical-devices/device-advice-comprehensive-regulatory-assistance/contact-us-division-industry-and-consumer-education-dice',
      ],
      dependsOn: ['6.1'],
    ),
    RegulatoryTask(
      id: '6.3',
      title: 'Prepare for FDA Meeting',
      description: 'If needed, schedule and prepare for interactive review meetings with FDA',
      resources: [
        'https://www.fda.gov/media/93740/download',
        'https://www.fda.gov/regulatory-information/search-fda-guidance-documents/requests-feedback-and-meetings-medical-device-submissions-q-submission-program',
      ],
      dependsOn: ['6.2'],
    ),
    
    // 7. Postmarket Compliance and Surveillance
    RegulatoryTask(
      id: '7.1',
      title: 'Complete Registration & Listing',
      description: 'Register establishment and list devices with FDA',
      resources: [
        'https://www.fda.gov/medical-devices/how-study-and-market-your-device',
        'https://www.fda.gov/medical-devices/device-registration-and-listing/how-register-and-list',
        'https://www.fda.gov/medical-devices/how-study-and-market-your-device/device-registration-and-listing',
      ],
      dependsOn: ['6.3'],
    ),
    RegulatoryTask(
      id: '7.2',
      title: 'Implement Complaint System',
      description: 'Establish system for handling customer complaints and adverse event reporting',
      resources: [
        'https://www.fda.gov/medical-devices/postmarket-requirements-devices/mandatory-reporting-requirements-manufacturers-importers-and-device-user-facilities',
        'https://www.fda.gov/medical-devices/medical-device-safety/medical-device-reporting-mdr',
      ],
      dependsOn: ['7.1'],
    ),
    RegulatoryTask(
      id: '7.3',
      title: 'Plan for Post-approval Studies',
      description: 'If required, establish protocols for continued studies after market approval',
      resources: [
        'https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpma/pma_pas.cfm',
        'https://www.fda.gov/medical-devices/postmarket-requirements-devices/522-postmarket-surveillance-studies-program',
      ],
      dependsOn: ['7.2'],
    ),
  ];
}

class FdaResource {
  final String title;
  final String url;
  final ResourceType type;

  FdaResource({
    required this.title,
    required this.url,
    this.type = ResourceType.guidance,
  });
}

enum ResourceType {
  guidance,
  form,
  regulation,
  other
}

