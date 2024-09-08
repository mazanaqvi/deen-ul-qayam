importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    databaseURL:
        'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
    apiKey: "AIzaSyBZLp0GKlwhrFBjRIEELxCvyVGj49_1VYw",
    authDomain: "myallapp-f9c13.firebaseapp.com",
    databaseURL: "https://myallapp-f9c13.firebaseio.com",
    projectId: "myallapp-f9c13",
    storageBucket: "myallapp-f9c13.appspot.com",
    messagingSenderId: "476849697961",
    appId: "1:476849697961:web:c6f7df346b69ce674f65b8"
});

// Necessary to receive background messages:
var messaging = firebase.messaging();
// // Optional:
// messaging.onBackgroundMessage((m) => {
//     console.log("onBackgroundMessage", m);
// });
messaging.onBackgroundMessage(messaging, (payload) => {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    // Customize notification here
    var notificationTitle = 'Background Message Title';
    var notificationOptions = {
        body: 'Background Message body.',
        icon: '/firebase-logo.png'
    };

    self.registration.showNotification(notificationTitle,
        notificationOptions);
});
