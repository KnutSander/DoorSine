# Firebase Security
Firebase uses HTTPS to encrypt data in transit.  
**Encryption:** Because HTTP was originally designed as a clear text protocol, it is vulnerable to eavesdropping and man in the middle attacks. By including SSL/TLS encryption, HTTPS prevents data sent over the internet from being intercepted and read by a third party. Through public-key cryptography and the SSL/TLS handshake, an encrypted communication session can be securely set up between two parties who have never met in person (e.g. a web server and browser) via the creation of a shared secret key.

**Authentication:** Unlike HTTP, HTTPS includes robust authentication via the SSL/TLS protocol. A website’s SSL/TLS certificate includes a public key that a web browser can use to confirm that documents sent by the server (such as HTML pages) have been digitally signed by someone in possession of the corresponding private key. If the server’s certificate has been signed by a publicly trusted certificate authority (CA), such as SSL.com, the browser will accept that any identifying information included in the certificate has been validated by a trusted third party.

HTTPS websites can also be configured for mutual authentication, in which a web browser presents a client certificate identifying the user. Mutual authentication is useful for situations such as remote work, where it is desirable to include multi-factor authentication, reducing the risk of phishing or other attacks involving credential theft. For more information on configuring client certificates in web browsers, please read this how-to.

**Integrity:** Each document (such as a web page, image, or JavaScript file) sent to a browser by an HTTPS web server includes a digital signature that a web browser can use to determine that the document has not been altered by a third party or otherwise corrupted while in transit. The server calculates a cryptographic hash of the document’s contents, included with its digital certificate, which the browser can independently calculate to prove that the document’s integrity is intact.

**Taken together, these guarantees of encryption, authentication, and integrity make HTTPS a much safer protocol for browsing and conducting business on the web than HTTP.**

The following Firebase services also encrypts their data at rest (When stored):
Cloud Firestore, Cloud Functions for Firebase, Cloud Storage for Firebase, Firebase Crashlytics, Firebase Authentication, Firebase Cloud Messaging, Firebase Realtime Database and Firebase Test Lab.

Sources:
[HTTPS](https://www.ssl.com/faqs/what-is-https/)
[Firebase Security](https://firebase.google.com/support/privacy#security_information)
