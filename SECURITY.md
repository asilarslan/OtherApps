# Security Policy

## Supported Versions

We actively support the following versions of OtherApps:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | ✅ |

## Reporting a Vulnerability

We take the security of OtherApps seriously. If you discover a security vulnerability, please follow these steps:

### How to Report

1. **Do NOT** create a public GitHub issue for security vulnerabilities
2. Send an email to: [your-email@example.com] with details about the vulnerability
3. Include as much information as possible:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Response Time**: We aim to acknowledge security reports within 48 hours
- **Updates**: We'll keep you informed about our progress in addressing the issue
- **Credit**: We'll credit you in our security advisories (unless you prefer to remain anonymous)

### Security Considerations

OtherApps library:
- Uses only public iTunes Search API
- Does not collect or store user data
- Does not require special permissions beyond network access
- All network requests are made to Apple's official endpoints

### Dependencies

This library has no external dependencies beyond iOS SDK frameworks:
- Foundation
- SwiftUI
- UIKit (for opening App Store URLs)

All network communications are handled through standard Apple frameworks with built-in security measures.

## Security Best Practices for Users

When using OtherApps in your applications:

1. **Validate URLs**: Ensure App Store URLs are legitimate before passing to the library
2. **Network Security**: Use App Transport Security (ATS) compliance
3. **Error Handling**: Implement proper error handling for network failures
4. **Rate Limiting**: Consider implementing rate limiting for API calls in production apps

## Contact

For security-related questions or concerns, contact us at [your-email@example.com]. 