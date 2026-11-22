const admin = require("firebase-admin");
const { HttpsError, onCall } =
  require("firebase-functions/v2/https");

admin.initializeApp();

exports.sendPushNotification = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Unauthenticated");
  }

  const { token, title, body, data } = request.data;
  if (!token) {
    throw new HttpsError("invalid-argument", "Missing token");
  }

  await admin.messaging().send({
    token,
    notification: { title, body },
    data: data || {},
  });

  return { success: true };
});
