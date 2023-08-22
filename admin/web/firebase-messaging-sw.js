importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

const firebaseConfig = {
  apiKey: "AIzaSyDlIo1PyMP-jCBJ8SZJMCy_2m9cE7gTFvs",
      authDomain: "sampleflutterproject-.firebaseapp.com",
      projectId: "sampleflutterproject-",
      storageBucket: "sampleflutterproject-.appspot.com",
      messagingSenderId: "1078614938637",
      appId: "1:1078614938637:web:6582c5752793b271113144",
      measurementId: "G-L23N47X0BZ"
};
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();


messaging.onMessage((payload) => {
  console.log('Message received. ', payload);
   const notificationTitle = payload.notification.title;
    const notificationOptions = {
    body: payload.notification.body,
    };
   self.registration.showNotification(notificationTitle, notificationOptions);
});




messaging.onBackgroundMessage((payload) => {
  console.log('Received background message ', payload);

  // Customize notification here
//  const notificationTitle = payload.notification.title;
//  const notificationOptions = {
//    body: payload.notification.body,
//    icon: '/firebase-logo.png'
//  };

//  self.registration.showNotification(notificationTitle, notificationOptions);
});
