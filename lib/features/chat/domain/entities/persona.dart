/// Enum representing the different AI mentor personas available in DevForge AI.
enum Persona {
  strictProfessor,
  placementGuru,
  startupSpeedster,
  openSourceSage;

  /// Get the display name for the persona.
  String get displayName {
    switch (this) {
      case Persona.strictProfessor:
        return 'Strict Professor';
      case Persona.placementGuru:
        return 'Placement Guru';
      case Persona.startupSpeedster:
        return 'Startup Speedster';
      case Persona.openSourceSage:
        return 'Open Source Sage';
    }
  }

  /// Get a brief description of the persona's teaching style.
  String get description {
    switch (this) {
      case Persona.strictProfessor:
        return 'Detail-oriented, emphasizes correctness and theoretical foundations.';
      case Persona.placementGuru:
        return 'Focuses on interview preparation and practical problem-solving.';
      case Persona.startupSpeedster:
        return 'Believes in rapid prototyping and learning through building.';
      case Persona.openSourceSage:
        return 'Values community, collaboration, and clean maintainable code.';
    }
  }

  /// Get the icon associated with the persona (using iconsax icons).
  String get icon {
    switch (this) {
      case Persona.strictProfessor:
        return 'iconsax:chalkboard-teacher';
      case Persona.placementGuru:
        return 'iconsax:user-check';
      case Persona.startupSpeedster:
        return 'iconsax:rocket';
      case Persona.openSourceSage:
        return 'iconsax:git-branch';
    }
  }
}