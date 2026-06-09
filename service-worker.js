const cacheName = "kid-daily-v3";
const appShell = [
  "/",
  "/index.html",
  "/daily.html",
  "/import.html",
  "/child.html",
  "/style.css",
  "/app.js",
  "/import.js",
  "/child.js",
  "/manifest.json",
  "/icon.svg"
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(cacheName).then((cache) => cache.addAll(appShell))
  );
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames
          .filter((name) => name !== cacheName)
          .map((name) => caches.delete(name))
      );
    })
  );
  self.clients.claim();
});

self.addEventListener("fetch", (event) => {
  if (event.request.method !== "GET") {
    return;
  }

  event.respondWith(
    fetch(event.request).then((networkResponse) => {
      const responseCopy = networkResponse.clone();

      caches.open(cacheName).then((cache) => {
        cache.put(event.request, responseCopy);
      });

      return networkResponse;
    }).catch(() => {
      return caches.match(event.request);
    })
  );
});
