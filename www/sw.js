// The War of Wings offline cache. Bump VERSION whenever the game files change.
const VERSION = 'the-war-of-wings-v1';
const FILES = ['./', './index.html', './manifest.webmanifest', './icons/icon-192.png', './icons/icon-512.png', './icons/icon-maskable-512.png', './icons/apple-touch-icon.png'];
self.addEventListener('install', e => { e.waitUntil(caches.open(VERSION).then(c => c.addAll(FILES)).then(() => self.skipWaiting())); });
self.addEventListener('activate', e => { e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== VERSION).map(k => caches.delete(k)))).then(() => self.clients.claim())); });
// same-site files: cache first. Fonts and other outside files: network first, cache as fallback.
self.addEventListener('fetch', e => {
  const req = e.request; if (req.method !== 'GET') return;
  if (new URL(req.url).origin === self.location.origin) e.respondWith(caches.match(req).then(hit => hit || fetch(req)));
  else e.respondWith(fetch(req).then(res => { const copy = res.clone(); caches.open(VERSION).then(c => c.put(req, copy)); return res; }).catch(() => caches.match(req)));
});
