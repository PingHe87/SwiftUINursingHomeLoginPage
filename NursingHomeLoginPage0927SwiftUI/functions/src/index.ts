import * as functions from "firebase-functions";
import sgMail from "@sendgrid/mail";

// Define the expected data structure for the Cloud Function
interface SendInvitationData {
  email: string;
  link: string;
  inviterName: string;
}

// Initialize SendGrid
sgMail.setApiKey(functions.config().sendgrid.key);

/**
 * Cloud Function: Send Invitation Email
 * Trigger: HTTPS Callable
 */
export const sendInvitationEmail = functions.https.onCall(
  async (request, context) => {
    // Extract data and validate its structure
    const data = request.data as SendInvitationData;
    const { email, link, inviterName } = data;

    if (!email || !link || !inviterName) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required fields: email, link, or inviterName."
      );
    }

    // Email message configuration
    const msg = {
      to: email,
      from: "heping.m87@gmail.com",
      subject: `${inviterName} has invited you to join Nursing Home App`,
      html: `
      <p>Hi,</p>
      <p>${inviterName} has invited you to join Nursing Home App.</p>
      <p>Please click the following link to complete your registration:</p>
      <a href="${link}">${link}</a>
      <p>This link will expire in 72 hours.</p>
    `,
    };

    try {
      // Send email
      await sgMail.send(msg);
      return { success: true };
    } catch (error) {
      console.error("Error sending email:", (error as Error).message);
      throw new functions.https.HttpsError(
        "internal",
        "Unable to send email. Please try again later."
      );
    }
  }
);
