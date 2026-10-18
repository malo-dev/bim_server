import axios from 'axios';

// GET /transport/geocode?address=... — convertit une adresse tapée par
// l'utilisateur en coordonnées GPS (Google Geocoding API), pour afficher un
// pin destination sur la carte et calculer une vraie distance (Haversine)
// au lieu du fallback déterministe basé sur le texte de l'adresse.
export const geocodeAddress = async (req, res) => {
  try {
    const { address } = req.query;
    if (!address || !address.trim()) {
      return res.status(400).json({ message: 'address est obligatoire' });
    }

    const apiKey = process.env.GOOGLE_MAPS_JS_API_KEY;
    if (!apiKey) return res.status(503).json({ message: 'Geocoding indisponible (clé API manquante)' });

    const resp = await axios.get('https://maps.googleapis.com/maps/api/geocode/json', {
      params: {
        address: `${address}, Kinshasa, République Démocratique du Congo`,
        key: apiKey,
      },
    });

    const result = resp.data?.results?.[0];
    if (!result) return res.status(404).json({ message: 'Adresse introuvable' });

    const { lat, lng } = result.geometry.location;
    return res.status(200).json({
      data: { lat, lng, formattedAddress: result.formatted_address },
    });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// GET /transport/autocomplete?input=... — suggestions d'adresses pendant la
// saisie du champ "Où allez-vous" (Google Places Autocomplete), limitées à la
// RDC pour ne proposer que des adresses pertinentes.
export const autocompleteAddress = async (req, res) => {
  try {
    const { input } = req.query;
    if (!input || !input.trim()) {
      return res.status(200).json({ data: [] });
    }

    const apiKey = process.env.GOOGLE_MAPS_JS_API_KEY;
    if (!apiKey) return res.status(503).json({ message: 'Autocomplete indisponible (clé API manquante)' });

    const resp = await axios.get('https://maps.googleapis.com/maps/api/place/autocomplete/json', {
      params: {
        input: input.trim(),
        key: apiKey,
        components: 'country:cd',
        location: '-4.4419,15.2663', // Kinshasa
        radius: 50000,
      },
    });

    const predictions = resp.data?.predictions || [];
    return res.status(200).json({
      data: predictions.map((p) => ({ placeId: p.place_id, description: p.description })),
    });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// GET /transport/place-details?placeId=... — résout une suggestion choisie
// dans la liste d'autocomplete en coordonnées GPS exactes.
export const placeDetails = async (req, res) => {
  try {
    const { placeId } = req.query;
    if (!placeId) return res.status(400).json({ message: 'placeId est obligatoire' });

    const apiKey = process.env.GOOGLE_MAPS_JS_API_KEY;
    if (!apiKey) return res.status(503).json({ message: 'Geocoding indisponible (clé API manquante)' });

    const resp = await axios.get('https://maps.googleapis.com/maps/api/place/details/json', {
      params: { place_id: placeId, key: apiKey, fields: 'geometry,formatted_address' },
    });

    const result = resp.data?.result;
    if (!result) return res.status(404).json({ message: 'Adresse introuvable' });

    const { lat, lng } = result.geometry.location;
    return res.status(200).json({
      data: { lat, lng, formattedAddress: result.formatted_address },
    });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

// Page carte BIM Transport — servie par le backend et chargée dans une WebView
// côté app mobile (pas de dépendance native react-native-maps, compatible Expo Go).
// La position du véhicule est mise à jour en direct depuis React Native via
// injectedJavaScript qui appelle window.updateChauffeurPosition(lat, lng).
export const renderTransportMap = (req, res) => {
  const apiKey = process.env.GOOGLE_MAPS_JS_API_KEY || '';

  if (!apiKey) {
    return res.status(200).send(`<!DOCTYPE html><html><body style="font-family:sans-serif;display:flex;align-items:center;justify-content:center;height:100vh;margin:0;color:#64748b">
      Carte indisponible (clé API manquante)
    </body></html>`);
  }

  const html = `<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <style>html,body,#map{height:100%;margin:0;padding:0;background:#EEF2F8}</style>
</head>
<body>
  <div id="map"></div>
  <script>
    let map, pickupMarker, destMarker, chauffeurMarker;
    const DEFAULT_CENTER = { lat: -4.4419, lng: 15.2663 }; // Kinshasa

    function post(type, payload) {
      if (window.ReactNativeWebView) {
        window.ReactNativeWebView.postMessage(JSON.stringify(Object.assign({ type }, payload || {})));
      }
    }

    function dotIcon(color) {
      return {
        path: google.maps.SymbolPath.CIRCLE,
        fillColor: color, fillOpacity: 1, strokeColor: '#fff', strokeWeight: 3, scale: 9,
      };
    }

    function initMap() {
      const params = new URLSearchParams(window.location.search);
      const pLat = parseFloat(params.get('pickupLat'));
      const pLng = parseFloat(params.get('pickupLng'));
      const dLat = parseFloat(params.get('destLat'));
      const dLng = parseFloat(params.get('destLng'));

      const center = (!isNaN(pLat) && !isNaN(pLng)) ? { lat: pLat, lng: pLng } : DEFAULT_CENTER;

      map = new google.maps.Map(document.getElementById('map'), {
        center: center, zoom: 14, disableDefaultUI: true, zoomControl: true, gestureHandling: 'greedy',
        styles: [
          { elementType: 'geometry', stylers: [{ color: '#f5f7fb' }] },
          { elementType: 'labels.text.fill', stylers: [{ color: '#64748b' }] },
          { elementType: 'labels.text.stroke', stylers: [{ color: '#ffffff' }] },
          { featureType: 'road', elementType: 'geometry', stylers: [{ color: '#ffffff' }] },
          { featureType: 'road', elementType: 'geometry.stroke', stylers: [{ color: '#e2e8f0' }] },
          { featureType: 'water', elementType: 'geometry', stylers: [{ color: '#dbeafe' }] },
          { featureType: 'poi', stylers: [{ visibility: 'off' }] },
          { featureType: 'transit', stylers: [{ visibility: 'off' }] }
        ]
      });

      const bounds = new google.maps.LatLngBounds();

      if (!isNaN(pLat) && !isNaN(pLng)) {
        pickupMarker = new google.maps.Marker({ position: { lat: pLat, lng: pLng }, map: map, icon: dotIcon('#0062FF') });
        bounds.extend(pickupMarker.getPosition());
      }
      if (!isNaN(dLat) && !isNaN(dLng)) {
        destMarker = new google.maps.Marker({ position: { lat: dLat, lng: dLng }, map: map, icon: dotIcon('#0F172A') });
        bounds.extend(destMarker.getPosition());
      }
      if (pickupMarker && destMarker && !bounds.isEmpty()) {
        map.fitBounds(bounds, 60);
      }

      post('ready', {});
    }

    // Appelé depuis React Native (injectedJavaScript) pour faire apparaître/bouger le véhicule
    window.updateChauffeurPosition = function(lat, lng) {
      if (!map) return;
      const pos = { lat: Number(lat), lng: Number(lng) };
      if (!chauffeurMarker) {
        chauffeurMarker = new google.maps.Marker({
          position: pos, map: map,
          icon: { path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW, scale: 6, fillColor: '#00D2FF', fillOpacity: 1, strokeColor: '#0062FF', strokeWeight: 2 },
          zIndex: 999
        });
      } else {
        animateMarkerTo(chauffeurMarker, pos);
      }
    };

    function animateMarkerTo(marker, newPos) {
      const start = marker.getPosition();
      const startLat = start.lat(), startLng = start.lng();
      const steps = 30;
      let i = 0;
      const interval = setInterval(function () {
        i++;
        marker.setPosition({
          lat: startLat + (newPos.lat - startLat) * (i / steps),
          lng: startLng + (newPos.lng - startLng) * (i / steps)
        });
        if (i >= steps) clearInterval(interval);
      }, 30);
    }

    window.onerror = function (msg) { post('error', { msg: String(msg) }); };
  </script>
  <script src="https://maps.googleapis.com/maps/api/js?key=${apiKey}&callback=initMap" async defer></script>
</body>
</html>`;

  res.setHeader('Content-Type', 'text/html; charset=utf-8');
  return res.status(200).send(html);
};
