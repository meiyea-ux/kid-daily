const cacheName = "kid-daily-v1";
const appShell = [
  "/",
  "/index.html",
  "/daily.html",
  "/import.html",
  "/style.css",
  "/app.js",
  "/import.js",
  "/manifest.json",
  "/icon.svg"
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(cacheName).then((cache) => cache.addAll(appShell))
  );
});

self.addEventListener("fetch", (event) => {
  if (event.request.method !== "GET") {
    return;
  }

  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      return cachedResponse || fetch(event.request);
    })
  );
});
