const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// User-based notification trigger
exports.sendUserNotification = functions.firestore
  .document("notifications/users/{userId}/{notifId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();
    const userId = context.params.userId;

    // Get user fcm token
    const userRef = await admin.firestore().collection("User").doc(userId).get();
    const fcmToken = userRef.data().fcmToken;

    const message = {
      token: fcmToken,
      notification: {
        title: data.title,
        body: data.body,
      },
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    await admin.messaging().send(message);
    console.log("Notification sent to:", userId);
  });

// Global notification trigger
exports.sendGlobalNotification = functions.firestore
  .document("notifications/global/items/{notifId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();

    // Get all users
    const users = await admin.firestore().collection("User").get();

    users.forEach((user) => {
      const fcmToken = user.data().fcmToken;

      admin.messaging().send({
        token: fcmToken,
        notification: {
          title: data.title,
          body: data.body,
        },
      });
    });

    console.log("Global notification sent!");
  });
