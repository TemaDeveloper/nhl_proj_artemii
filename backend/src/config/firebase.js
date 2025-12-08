import * as fs from 'fs';
import admin from 'firebase-admin';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const initializeFirebase = () => {
  try {
    const credentialsFilename = process.env.FIREBASE_CREDENTIALS_PATH || 'service-account-key.json';
    const credentialsPath = join(__dirname, '../../', credentialsFilename);

    if (!fs.existsSync(credentialsPath)) {
      throw new Error(`Credentials file not found at ${credentialsPath}`);
    }

    const serviceAccountContent = fs.readFileSync(credentialsPath, 'utf8');
    const serviceAccount = JSON.parse(serviceAccountContent);

    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });

    console.log('Firebase Admin SDK Initialized Successfully.');
    return admin.firestore();
  } catch (error) {
    console.error("ERROR: Failed to initialize Firebase Admin SDK.");
    console.error(`Reason: ${error.message}`);
    process.exit(1);
  }
};

const db = initializeFirebase();
export default db;