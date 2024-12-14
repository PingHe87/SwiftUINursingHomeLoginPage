"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendInvitationEmail = void 0;
const functions = __importStar(require("firebase-functions"));
const mail_1 = __importDefault(require("@sendgrid/mail"));
// Initialize SendGrid
mail_1.default.setApiKey(functions.config().sendgrid.key);
/**
 * Cloud Function: Send Invitation Email
 * Trigger: HTTPS Callable
 */
exports.sendInvitationEmail = functions.https.onCall(async (request, context) => {
    // Extract data and validate its structure
    const data = request.data;
    const { email, link, inviterName } = data;
    if (!email || !link || !inviterName) {
        throw new functions.https.HttpsError("invalid-argument", "Missing required fields: email, link, or inviterName.");
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
        await mail_1.default.send(msg);
        return { success: true };
    }
    catch (error) {
        console.error("Error sending email:", error.message);
        throw new functions.https.HttpsError("internal", "Unable to send email. Please try again later.");
    }
});
//# sourceMappingURL=index.js.map