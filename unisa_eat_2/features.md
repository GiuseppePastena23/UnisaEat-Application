# Features UnisaEat

## Overview
Documento che descrive le funzionalità sviluppate nell'applicazione UnisaEat (versione 0.1.0) con analisi delle metriche IS (Information System Metrics).

---

## Metriche IS Generali del Progetto

| Metrica | Valore | Descrizione |
|---------|--------|-------------|
| **LOC (Lines of Code)** | 3,277 | Totale righe di codice nel progetto |
| **NOF (Number of Files)** | ~82 | Numero di file Dart nel progetto |
| **NOP (Number of Packages)** | 16 | Dipendenze nel pubspec.yaml |
| **Architecture** | Clean Architecture | Layered: Data → Domain → Presentation |

---

## 1. Autenticazione (Authentication)

### Descrizione
Sistema di autenticazione degli utenti per l'accesso all'applicazione universitaria.

### Funzionalità
- **Login**: Accesso con email e password
- **Session Management**: Salvataggio token con JWT
- **Secure Storage**: Token salvati con FlutterSecureStorage
- **User State**: Gestione stato utente con BLoC Pattern

### Componenti Implementati

#### Presentation Layer
- `login.dart` (169 LOC) - Interfaccia login con form e validazione
- `signup.dart` - Pagina registrazione
- `LoginCubit` - State management per autenticazione
- `LoginState` - Stati: LoginLoading, LoginSuccess, LoginFailure

#### Domain Layer
- `login.dart` (UseCase) - Logica di login
- `logout.dart` (UseCase) - Logica di logout
- `auth_repository.dart` - Interfaccia repository

#### Data Layer
- `auth_repository.dart` - Implementazione repository
- `auth_api_service.dart` - Servizio API con Dio
- `log_in_params.dart` - Modello parametri login

### Metriche IS - Autenticazione

| Metrica | Valore | Note |
|---------|--------|------|
| LOC | ~250 | Righe di codice modulo auth |
| CC (Cyclomatic Complexity) | Basso | < 5 per metodo |
| CBO (Coupling) | Medio | Accoppiamento con UserProfileCubit |
| RFC (Response for Class) | 8-10 | Metodi responsivi per classe |

### Dettagli Tecnici
- **State Management**: Flutter BLoC (Cubit pattern)
- **API**: REST con Dio client
- **Storage**: flutter_secure_storage per token JWT
- **Validation**: Validazione lato client e server
- **Loading States**: Animazioni di caricamento (loading_animation_widget)

---

## 2. Visualizzazione Menu (Menu Viewer)

### Descrizione
Visualizzazione del menu giornaliero della mensa universitaria con possibilità di navigare tra date.

### Funzionalità
- **Daily Menu**: Visualizzazione piatti del giorno
- **Date Navigation**: Selettore data (solo giorni feriali)
- **Category Grouping**: Piatti raggruppati per categoria
- **Dish Details**: Nome, descrizione, prezzo, allergeni
- **Italian Localization**: Date e testi in italiano
- **Error Handling**: Gestione errori con retry

### Componenti Implementati

#### Presentation Layer
- `menu.dart` (329 LOC) - Interfaccia principale menu
- `MenuCubit` - State management menu
- `MenuState` - Stati: MenuLoading, MenuLoaded, MenuError

#### Domain Layer
- `menu_entity.dart` - Entità menu
- `piatto_entity.dart` - Entità piatto
- `menu_repository.dart` - Interfaccia repository
- `get_menu_by_date_usecase.dart` - UseCase per fetch menu

#### Data Layer
- `menu_repository.dart` - Implementazione repository
- `menu_api_service.dart` - Servizio API
- `menu_model.dart` - Modello dati
- `piatto_model.dart` - Modello piatto

#### Utils
- `date_utils.dart` - Utility formattazione date
- `menu_mapper.dart` - Mapper Model → Entity
- `piatto_mapper.dart` - Mapper Model → Entity

### Metriche IS - Menu

| Metrica | Valore | Note |
|---------|--------|------|
| LOC | ~450 | Righe di codice modulo menu |
| CC | Medio | 5-8 per metodo (buildMenu, grouping) |
| CBO | Basso | Modulo relativamente indipendente |
| WMC (Weighted Methods) | 6-8 | Peso medio dei metodi |
| LCOM (Lack of Cohesion) | Basso | Alta coesione interna |

### Dettagli Tecnici
- **State Management**: Flutter BLoC (Cubit pattern)
- **Date Picker**: Flutter native date picker
- **Caching**: Hive per caching menu locale
- **Categories**: Primi, Secondi, Contorni, Dolce, Bevande
- **Allergens**: Warning visivo con icona ⚠️

---

## 3. Wallet (Portafoglio Digitale)

### Descrizione
Sistema di gestione credito per acquisti alla mensa.

### Funzionalità
- **Balance Display**: Visualizzazione saldo corrente
- **Add Funds**: Pagamento per ricarica (PayPal)
- **Transaction History**: Lista transazioni recenti
- **Transaction Types**: Ricariche (+), Acquisti (-)
- **Date Formatting**: Formattazione italiana date

### Componenti Implementati

#### Presentation Layer
- `wallet_page.dart` (154 LOC) - Pagina principale wallet
- `add_funds_page.dart` - Pagina ricarica fondi
- `WalletCubit` - State management wallet
- `WalletState` - Stati: WalletLoading, WalletSuccess, WalletFailure

#### Domain Layer
- `transaction_entity.dart` - Entità transazione
- `wallet_repository.dart` - Interfaccia repository
- `get_balance_usecase.dart` - UseCase get saldo
- `get_transactions_usecase.dart` - UseCase transazioni

#### Data Layer
- `wallet_repository.dart` - Implementazione repository
- `wallet_api_service.dart` - Servizio API
- `transaction_model.dart` - Modello dati
- `transaction_mapper.dart` - Mapper Model → Entity

### Metriche IS - Wallet

| Metrica | Valore | Note |
|---------|--------|------|
| LOC | ~400 | Righe di codice modulo wallet |
| CC | Basso-Medio | 3-6 per metodo |
| CBO | Medio | Accoppiamento con payment gateway |
| RFC | 6-8 | Response methods limitati |
| DIT (Depth of Inheritance) | 1 | BaseEntity → TransactionEntity |

### Dettagli Tecnici
- **Payment**: PayPal SDK (flutter_paypal_payment)
- **State Management**: Flutter BLoC (Cubit pattern)
- **Transaction Formatting**: Segno (+/-), colore (verde/rosso)
- **Balance Display**: Formattazione 2 decimali con Euro

---

## 4. QR Code (Identificazione Digitale)

### Descrizione
Generazione QR code per identificazione personale alla mensa.

### Funzionalità
- **QR Generation**: Creazione QR code dinamico
- **User Data**: Integrazione dati utente
- **Modal Dialog**: Visualizzazione in overlay
- **Blur Effect**: Effetto blur background (BackdropFilter)

### Componenti Implementati

#### Presentation Layer
- `home.dart` (69 LOC) - Homepage con QR FAB
- `qr_dialog.dart` - Dialog QR code
- `qr_code_cubit.dart` - State management QR
- `qr_code_state.dart` - Stati QR

#### Domain Layer
- `get_qr_code.dart` (UseCase) - Logica generazione QR
- `home_repository.dart` - Interfaccia repository

#### Data Layer
- `home_repository.dart` - Implementazione repository
- `home_api_service.dart` - Servizio API

### Metriche IS - QR Code

| Metrica | Valore | Note |
|---------|--------|------|
| LOC | ~200 | Righe di codice modulo QR |
| CC | Molto Basso | 1-2 per metodo |
| CBO | Basso | Modulo isolato |
| RFC | 3-4 | Metodi responsivi limitati |

### Dettagli Tecnici
- **Library**: qr_flutter
- **UI**: Floating action button, blur backdrop
- **Integration**: User profile data

---

## 5. Profilo Utente (User Profile)

### Descrizione
Visualizzazione e gestione informazioni personali.

### Funzionalità
- **Profile Display**: Nome, email, dettagli
- **Header Integration**: ProfileAppBar condiviso
- **Caching**: Persistenza dati con Hive
- **State Management**: UserProfileCubit globale

### Componenti Implementati

#### Presentation Layer
- `user_profile_page.dart` - Pagina profilo
- `user_profile_cubit.dart` - State management globale
- `user_profile_state.dart` - Stati profilo
- `profile_app_bar.dart` - Widget app bar condiviso

#### Domain Layer
- `user_entity.dart` - Entità utente
- `cached_user.dart` - Entità cache
- `user_repository.dart` - Interfaccia repository
- `get_user.dart` (UseCase) - Recupero dati utente

#### Data Layer
- `user_repository.dart` - Implementazione repository
- `user_api_service.dart` - Servizio API
- `user_model.dart` - Modello dati
- `user_mapper.dart` - Mapper Model → Entity

### Metriche IS - User Profile

| Metrica | Valore | Note |
|---------|--------|------|
| LOC | ~350 | Righe di codice modulo user |
| CC | Basso | 2-4 per metodo |
| CBO | Alto | Accoppiato con molti moduli |
| WMC | 5-7 | Metodi ben bilanciati |
| LCOM | Basso | Alta coesione |

### Dettagli Tecnici
- **Caching**: Hive (cached_user)
- **Adapters**: UserEntityAdapter, CachedUserAdapter
- **Storage**: Box 'user' persistente
- **Integration**: BlocProvider globale (main.dart)

---

## 6. Navigazione e Routing

### Descrizione
Sistema di navigazione dell'applicazione con go_router.

### Funzionalità
- **Declarative Routing**: go_router configuration
- **Protected Routes**: Rotte con autenticazione
- **Bottom Navigation**: Navigazione tab-based
- **Shell Layout**: Scaffold condiviso

### Componenti Implementati

#### Routing
- `app_router.dart` - Configurazione router principale
- `bottom_nav_bar.dart` - Widget bottom navigation
- `shell_scaffold.dart` - Scaffold condiviso

### Rotte Definite
```
/                           → Home (Login required)
/login                      → Login page
/signup                     → Signup page
/menu                       → Menu viewer
/wallet                     → Wallet page
/wallet/add-funds/          → Add funds
/user/profile               → User profile
```

### Metriche IS - Routing

| Metrica | Valore | Note |
|---------|--------|------|
| LOC | ~150 | Righe codice routing |
| CC | Basso | Struttura dichiarativa |
| CBO | Medio | Accoppiamento con tutte le pagine |

---

## 7. Componenti UI Riutilizzabili

### Descrizione
Widget condivisi tra più schermate.

### Componenti

| Widget | LOC | Descrizione |
|--------|-----|-------------|
| `custom_card.dart` | ~50 | Card riutilizzabile |
| `tappable_image.dart` | ~60 | Immagine con tap e routing |
| `qr_dialog.dart` | ~80 | Dialog QR code |

---

## Architettura Tecnica

### Pattern Architetturali

| Pattern | Utilizzo |
|---------|----------|
| Clean Architecture | Layered: Data → Domain → Presentation |
| BLoC Pattern | State management (Cubit) |
| Repository Pattern | Astrazione accesso dati |
| UseCase Pattern | Logica business encapsulation |
| Service Locator | Dependency Injection (get_it) |

### Dependency Injection

**Service Locator** (`service_locator.dart`)
- `get_it` per dependency injection
- Singleton pattern per repository
- Lazy loading per cubits

### Networking

**Dio Client** (`dio_client.dart`)
- HTTP client configurato
- Interceptors per logging e auth
- Base URL configuration
- Error handling centralizzato

### Data Persistence

**Hive (NoSQL Database)**
- User cache (Box: 'user')
- Menu cache (Box: 'menu')
- TypeAdapters per custom entities

**Secure Storage**
- JWT tokens (flutter_secure_storage)
- Authentication data

---

## Metriche IS Complessive

### Tabella Riepilogativa

| Categoria | LOC | Files | CC Medio | CBO | RFC |
|-----------|-----|-------|----------|-----|-----|
| Auth | ~250 | 8 | 3-5 | Medio | 8-10 |
| Menu | ~450 | 10 | 5-8 | Basso | 6-9 |
| Wallet | ~400 | 9 | 3-6 | Medio | 6-8 |
| QR Code | ~200 | 6 | 1-2 | Basso | 3-4 |
| User Profile | ~350 | 9 | 2-4 | Alto | 5-7 |
| Routing/UI | ~250 | 5 | 2-3 | Medio | 4-6 |
| **TOTALE** | **~1,900** | **~47** | **~3-5** | **Medio** | **~5-8** |

*Nota: LOC calcolati sui file principali, escluse le classi generate (.g.dart) e utilities.*

### Indicatori di Qualità IS

| Indicatore | Valutazione | Descrizione |
|------------|-------------|-------------|
| **Maintainability** | Alta | Clean architecture, bassa complessità |
| **Testability** | Media | Dependency injection, separazione layer |
| **Modularity** | Alta | Moduli ben separati, accoppiamento ridotto |
| **Extensibility** | Alta | Pattern usecase, repository aperti |
| **Code Reusability** | Media-Alta | Widget condivisi, helper utilities |

---

## Dipendenze Principali

| Package | Versione | Utilizzo |
|---------|----------|----------|
| flutter_bloc | - | State management |
| dio | - | HTTP client |
| get_it | - | Dependency injection |
| hive_flutter | - | Local storage |
| flutter_secure_storage | ^9.2.1 | Secure token storage |
| go_router | - | Declarative routing |
| qr_flutter | - | QR code generation |
| flutter_paypal_payment | ^1.0.7 | PayPal integration |
| google_fonts | - | Custom fonts |
| loading_animation_widget | - | Loading animations |

---

## TODO List (Attuale)

1. Error handling quando server è offline (login)
2. Semplificazione Dio con helper class
3. App versioning (versioning chiave)
4. Validazione email/password client-side prima di chiamata server
5. Skeletonizer per loading states
6. Display saldo in appbar shell
7. Spostamento saldo in UserProfileCubit

---

## Conclusioni

L'applicazione UnisaEat v0.1.0 presenta un'architettura ben strutturata basata su Clean Architecture Pattern con:

- **Modularità Alta**: Feature separate (Auth, Menu, Wallet, QR, User)
- **Complexity Controllata**: CC medio 3-5, buona manutenibilità
- **Code Quality**: Pattern consolidati (BLoC, Repository, UseCase)
- **User Experience**: UI moderna, animazioni, navigazione fluida

**Punti di Forza**:
- Architettura scalabile e manutenibile
- Separazione responsabilità chiara
- State management centralizzato
- Persistenza dati robusta

**Aree di Miglioramento**:
- Unit testing (mancante)
- Integration testing
- Error handling avanzato
- Offline mode

---

*Documento generato: 10 Gennaio 2026*
*Versione App: 0.1.0*
*Flutter SDK: ^3.9.2*
