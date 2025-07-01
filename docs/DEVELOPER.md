# Nino Web Alkalmazás Fejlesztői Dokumentáció

## Tartalomjegyzék
- [Architektúra áttekintés](#architektúra-áttekintés)
- [Projekt struktúra](#projekt-struktúra)
- [Technológiák és függőségek](#technológiák-és-függőségek)
- [Szolgáltatások](#szolgáltatások)
- [Modellek](#modellek)
- [Kontrollerek](#kontrollerek)
- [Nézetek](#nézetek)
- [Beállítás és konfiguráció](#beállítás-és-konfiguráció)
- [Projekt indítása](#projekt-indítása)

## Architektúra áttekintés

A Nino Web alkalmazás a Model-View-Controller (MVC) architektúrát követi, Flutter webes megvalósítással. Ez a struktúra tiszta szétválasztást, moduláris felépítést és jól karbantartható kódbázist biztosít. Az adatok, a felhasználói felület és az üzleti logika elkülönülten kezelhető, így a fejlesztés és a hibakeresés is átláthatóbb.

### MVC megvalósítás a projektben
- **Modellek**: Adatszerkezetek, marker és kategória modellek, valamint az ezekhez tartozó adatfeldolgozó logika (pl. Supabase-ből érkező adatok konvertálása)
- **Nézetek**: Felhasználói felület, vizuális komponensek és widgetek (térkép, oldalsó panelek, marker lista, stb.), amelyek a kontrollerek által biztosított adatokat jelenítik meg
- **Kontrollerek**: Állapotkezelés, üzleti logika koordináció, felhasználói interakciók kezelése (pl. marker kiválasztás, panelek nyitása/zárása, marker stream figyelése)

## Projekt struktúra

```
lib/
├── core/
│   ├── constants/
│   │   └── constants.dart
│   └── services/
│       ├── location_service.dart
│       ├── marker_icon_service.dart
│       └── supabase_service.dart
├── controllers/
│   ├── marker_controller.dart
│   └── ui_state_controller.dart
├── models/
│   ├── category.dart
│   └── marker_model.dart
├── views/
│   ├── map_view.dart
│   └── widgets/
│       ├── map_widget.dart
│       ├── marker_widget.dart
│       └── side_panel/
│           ├── header_row_widget.dart
│           ├── link_row_widget.dart
│           ├── multi_marker_panel_widget.dart
│           └── side_panel_widget.dart
└── main.dart
```

## Technológiák és függőségek

### Keretrendszer
- **Flutter SDK**: ^3.8.0-177.0.dev
- **Dart**: A Flutter SDK-val kompatibilis legfrissebb stabil verzió

## Supabase Integráció

A Nino Web alkalmazás a [Supabase](https://supabase.com/) backend-szolgáltatást (BaaS) használja, amely adatbázis, hitelesítés és tárolási funkciókat biztosít.

### Használt Supabase Szolgáltatások

#### 1. PostgreSQL Adatbázis
- Tárolja az összes marker adatot, beleértve a koordinátákat, kategóriákat és metaadatokat
- Fő tábla:
  - `reports` - Tárolja a földrajzi markereket a következő mezőkkel:
    - `id` (UUID elsődleges kulcs)
    - `coordinates` (Koordináták)
    - `category` (szöveg)
    - `originator` (UUID, auth.users-ra hivatkozik)
    - `created_at` (időbélyeg)

#### 2. Tároló (Storage)
- Marker képeket tárol a következő bucket-ekben:
  - `news` - Feltöltött marker fotókat tartalmaz

### Konfiguráció

Környezeti változók a `.env` fájlban:
```env
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### Főbb függőségek
- **cupertino_icons**: ^1.0.8 - iOS stílusú ikonok
- **supabase_flutter**: ^2.8.4 - Backend as a Service (BaaS) integráció
- **flutter_dotenv**: ^5.2.1 - Környezeti változók kezelése
- **font_awesome_flutter**: ^10.8.0 - Extra ikon készlet
- **google_maps_flutter**: ^2.11.0 - Google Maps integráció
- **geolocator**: ^13.0.3 - Helymeghatározás
- **cached_network_image**: ^3.4.1 - Képek cache-elése
- **http**: ^1.3.0 - HTTP kliens API hívásokhoz
- **web**: ^1.1.1 - Web specifikus funkcionalitás

### Fejlesztői függőségek
- **flutter_lints**: ^5.0.0 - Dart/Flutter kódellenőrzés
- **flutter_test** - Tesztelési keretrendszer

## Szolgáltatások

### Location Service
Elérhető: `lib/core/services/location_service.dart`
- Felhasználói helymeghatározási engedélyek kezelése (engedélykérés, jogosultság ellenőrzés)
- Aktuális földrajzi pozíció lekérése (GPS koordináták)
- Folyamatos helyfrissítések figyelése és kezelése
- Helymeghatározási hibák, jogosultság-változások kezelése
- A Geolocator csomag használatával biztosítja a platformfüggetlen helyszolgáltatásokat

### Marker Icon Service
Elérhető: `lib/core/services/marker_icon_service.dart`
- Egyedi marker ikonok dinamikus létrehozása, rajzolása és cache-elése
- Hálózati képek betöltése és beágyazása a marker ikonba
- Marker ikonok testreszabása kategória színnel, lekerekített sarkokkal és háromszög alakú mutatóval
- A marker ikonok gyors eléréséhez belső cache-t használ (`_cache`)
- A `createMarkerIcon` aszinkron metódus egyedi, képes marker ikont generál a megadott MarkerModel alapján, és visszaadja BitmapDescriptor formátumban
- Tartalmaz segédfüggvényeket a marker grafikai elemeinek (alakzat, háromszög, képkeret) elkészítéséhez
- A cache tartalma a `clearCache` metódussal üríthető

### Supabase Service
Elérhető: `lib/core/services/supabase_service.dart`
- Supabase adatbázis kapcsolat inicializálása és kezelése
- Marker adatok lekérdezése, létrehozása, frissítése és törlése (CRUD)
- Képek URL-jének lekérése a Supabase storage-ból (pl. getImageUrlFromNewsBucket)
- Aszinkron műveletek a gyors és reszponzív adatkezeléshez
- Hibakezelés és visszajelzés az adatbázis műveletek során

## Modellek

### Marker Model
Elérhető: `lib/models/marker_model.dart`
- Egy marker (jelölő) összes adatát tartalmazó modellosztály
- Tulajdonságai: azonosító, szerző azonosítója, pozíció (LatLng), kép URL, kategória, időbélyeg
- A `fromSupabase` aszinkron metódus segítségével képes Supabase-ből érkező adatokat átalakítani MarkerModel példánnyá, beleértve a kép URL lekérését is
- A marker kategóriát a `MarkerCategoryColor.fromString` metódus dolgozza fel
- A pozíciót a Google Maps `LatLng` objektuma reprezentálja

### Category
Elérhető: `lib/models/category.dart`
- Marker kategóriák (típusok) definiálása és kezelése
- Minden kategóriához tartozik egyedi szín (color) és elnevezés
- Kategória-specifikus megjelenítés, például ikon vagy szín a térképen
- Segédfüggvények a kategória konvertálásához (pl. fromString)
- A marker modellekhez kapcsolódó kategória logika központi helyen

## Kontrollerek

### Marker Controller
Elérhető: `lib/controllers/marker_controller.dart`
- Markerek állapotának, láthatóságának és műveleteinek kezelése (folyamatos marker stream figyelése, szűrés, rendezés)
- Marker létrehozás, frissítés, törlés, valamint marker ikonok generálása és hozzárendelése
- Látható markerek szűrése térképhatár és zoom szint alapján, maximum 50 markerig
- Marker kiválasztás és térképre kattintás kezelése, ezek továbbítása a UIStateController felé
- Belső cache a marker objektumokhoz, aszinkron adatfeldolgozás
- Stream subscription kezelés, erőforrások felszabadítása dispose során

### UI State Controller
Elérhető: `lib/controllers/ui_state_controller.dart`
- Az alkalmazás UI állapotának központi kezelése (oldalsó panel, marker kiválasztás, multi marker panel)
- Marker kiválasztás, panel nyitás/zárás, térképre kattintás logika
- Felhasználói interakciók (UI és térkép) szinkronizálása, rövid késleltetéssel az ütközések elkerülésére
- Állapotváltozásoknál automatikus értesítés a listenerek felé (`notifyListeners`)
- Reszponzív nézetek és panelek dinamikus megjelenítése/elrejtése
- Kiválasztott marker és panel állapotok lekérdezése gettereken keresztül

## Nézetek

### Map View
Elérhető: `lib/views/map_view.dart`
- Az alkalmazás fő nézeti konténere, amely a térképet és a kapcsolódó UI paneleket (oldalsó panel, marker panel) tartalmazza
- A Google Maps widget integrációja, marker megjelenítés és interakciók kezelése
- Oldalsó panel(ek) dinamikus megjelenítése/elrejtése a UIStateController állapota alapján
- Elrendezés és reszponzivitás: asztali és mobil nézetek támogatása, méretezés és igazítás
- Felhasználói események (marker kiválasztás, térképre kattintás) továbbítása a megfelelő kontrollerekhez

### Widgetek
Elérhető: `lib/views/widgets/`
- **Map Widget**: Google Maps integráció, marker és térképes interakciók kezelése
- **Marker Widget**: Egyedi marker ikonok és markerhez tartozó információk megjelenítése
- **Side Panel**: Többféle információs és interakciós panel, dinamikusan jelenik meg a UIStateController állapota alapján
  - **Header Row Widget**: Alkalmazás logója, címe, fő navigációs elemek
  - **Link Row Widget**: Navigációs linkek, külső hivatkozások, elrendezés igazítása asztali/mobil nézethez
  - **Side Panel Widget**: Egy marker részletes adatainak, képének, kategóriájának, leírásának megjelenítése
  - **Multi Marker Panel Widget**: Több marker egyidejű kiválasztásának és kezelésének felülete, lista vagy grid nézetben

## Beállítás és konfiguráció

### Környezeti beállítás
1. Hozz létre egy `.env` fájlt a gyökérkönyvtárban
2. Állítsd be a következő változókat:
   - Google Maps API kulcs
   - Supabase URL
   - Supabase Anonymous Key

### Web konfiguráció
A webes belépési pont (`web/index.html`) tartalmazza:
- Google Maps API integráció
- Flutter web bootstrap
- Meta beállítások a webalkalmazáshoz

### Asset konfiguráció
Az asseteket a `pubspec.yaml`-ban kell beállítani:
```yaml
flutter:
  assets:
    - assets/icons/nino.png
    - assets/styles/map_style.json
    - .env

  fonts:
    - family: ChakraPetch
      fonts:
        - asset: assets/fonts/ChakraPetch-Regular.ttf
        - asset: assets/fonts/ChakraPetch-Bold.ttf
          weight: 700
```

## Google Maps API kulcs létrehozása

A projekt futtatásához szükség van egy érvényes Google Maps API kulcsra, amelyet a `.env` fájlban kell megadni.

**Lépések:**
1. Lépj be a [Google Cloud Console](https://console.cloud.google.com/) felületre.
2. Hozz létre egy új projektet, vagy válassz ki egy meglévőt.
3. Navigálj az "APIs & Services" > "Credentials" menüpontra.
4. Kattints az "+ CREATE CREDENTIALS" gombra, majd válaszd az "API key" opciót.
5. Az elkészült kulcsot másold be a `.env` fájlba:
   ```env
   GOOGLE_MAPS_API_KEY=ide_illeszd_be_a_kulcsot
   ```
6. Engedélyezd a "Maps JavaScript API"-t a projektedben az "APIs & Services" > "Library" menüpontban.

További részletek: [Google Maps API kulcs létrehozása - hivatalos dokumentáció](https://developers.google.com/maps/documentation/javascript/get-api-key)

## Fejlesztési irányelvek

### Kódstílus
- Kövesd a Flutter/Dart stílus irányelveket
- Használd a `flutter_lints` szabályait
- Következetes fájl- és mappanév konvenciók

### Állapotkezelés
- Kontrollereket használj az állapotkezeléshez
- Az üzleti logika a kontrollerekben és szolgáltatásokban legyen
- Egyirányú adatfolyam fenntartása

### Tesztelés
- Írj egységteszteket a modellekhez és szolgáltatásokhoz
- Widget tesztek a UI komponensekhez
- Integrációs tesztek a fő felhasználói folyamatokra

### Teljesítmény
- Megfelelő cache-elési stratégiák
- Marker renderelés optimalizálása
- Lusta betöltés használata, ahol lehet
- Memóriahasználat figyelése nagy adathalmazoknál

## Projekt indítása

1. **Repository klónozása**
   ```sh
   git clone https://github.com/martonszucs/nino_web.git
   cd nino-web
   ```
2. **Függőségek telepítése**
   ```sh
   flutter pub get
   ```
3. **.env fájl létrehozása**
   - Másold vagy hozd létre a `.env` fájlt a projekt gyökerében a szükséges kulcsokkal (Google Maps API kulcs, Supabase URL, Supabase Anonymous Key).
4. **Webes fejlesztői szerver indítása**
   ```sh
   flutter run -d chrome
   ```
5. **Elérhető a böngészőben**
   - Alapértelmezett cím: [http://localhost:5000](http://localhost:5000) vagy amit a Flutter kiír.

**Megjegyzés:**
- A Google Maps és Supabase működéséhez érvényes API kulcsok szükségesek.
- Ha először futtatod, a Flutter SDK-t is telepítened kell: [Flutter telepítési útmutató](https://docs.flutter.dev/get-started/install)
