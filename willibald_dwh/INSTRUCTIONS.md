# Willibald DWH – Projektanleitung

## Überblick

Dieses dbt-Projekt implementiert ein **Data Vault 2.0 Data Warehouse** auf Basis des Willibald-Webshop-Szenarios.
Es dient als praktische Grundlage für die Lehrveranstaltung BIS242.

Das Projekt ist auf **max. 40 Datenbank-Objekte pro Gruppe** optimiert, damit der gemeinsam genutzte Databricks-Community-Workspace (max. 500 Tabellen für 10 Gruppen) nicht an Kapazitätsgrenzen stößt.

---

## Schichtenarchitektur

| Schicht | Ordner | Schema | Materialisierung | Beschreibung |
|---------|--------|--------|------------------|--------------|
| **Seeds** | `seeds/02_sl_psa/` | `sl_psa` | table (seed) | Persistierte Staging-Daten aus dem Willibald-Webshop mit CDC-Spalten |
| **Meta-Seeds** | `seeds/00_cl_meta/` | `cl_meta` | table (seed) | Ladehistorie (`loading_history`) |
| **PSA-Views** | `models/02_sl_psa/` | `sl_psa` | view | Current-Flag-Berechnung über `psa_view`-Makro |
| **Raw Data Vault** | `models/03_il_rdv/` | `il_rdv` | view | Hubs, Links, Satellites, DK-LSATs, Referenztabellen |
| **Business Data Vault** | `models/04_il_bdv/` | `il_bdv` | view | Bridge-Tabellen, berechnete Satelliten (von Studierenden zu erstellen) |
| **Data Mart** | `models/05_ol_dm/` | `ol_dm` | table | Star-Schema mit Fakten- und Dimensionstabellen (von Studierenden zu erstellen) |

---

## Aktive Modelle (32 Objekte)

### Seeds (7)

| Seed | Unique Key | Beschreibung |
|------|-----------|--------------|
| `loading_history` | `loadingid` | Drei Ladeperioden (12.03., 14.03., 20.03.2022) |
| `webshop_bestellung` | `bestellungid` | Webshop-Bestellungen |
| `webshop_kunde` | `kundeid` | Kundenstammdaten |
| `webshop_position` | `bestellungid, posid` | Bestellpositionen |
| `webshop_produkt` | `produktid` | Produktstammdaten |
| `webshop_produktkategorie` | `katid` | Produktkategorien (hierarchisch) |
| `webshop_ref_produkt_typ` | `typ` | Referenztabelle Produkttypen |

### PSA-Views (6)

Jede PSA-View wird über das Makro `psa_view()` erzeugt und ergänzt ein `sys_islatest`-Flag per `LEAD()`-Fenster.

### Raw Data Vault (19)

| Typ | Modelle | Anzahl |
|-----|---------|--------|
| **Hubs** | `hub_customer`, `hub_product`, `hub_productcategory`, `hub_webshoporder`, `hub_webshoporderitem` | 5 |
| **Links** | `lnk_product_productcategory`, `lnk_webshoporder_customer`, `lnk_webshoporderitem_product`, `lnk_webshoporderitem_webshoporder` | 4 |
| **Satellites** | `sat_customer_context`, `sat_product_context`, `sat_productcategory_context`, `sat_webshoporder_context`, `sat_webshoporderitem_context` | 5 |
| **DK-LSATs** | `lsat_product_productcategory_dkh`, `lsat_webshoporder_customer_dkh`, `lsat_webshoporderitem_product_dkh`, `lsat_webshoporderitem_webshoporder_dkh` | 4 |
| **Referenztabellen** | `ref_producttype` | 1 |

---

## Makros

| Makro | Zweck |
|-------|-------|
| `hub()` | Hub-Lademuster: UNION über Quellen, Hash-Key, Deduplizierung |
| `link()` | Link-Lademuster: Hash-Keys für Link + referenzierte Hubs |
| `sat()` | Satelliten-Lademuster: Hash-Key + Checksumme, Change Detection |
| `dk_lsat()` | Driving-Key LSAT: Gültigkeitsfenster über Driving Key |
| `hashcolumn()` | Wrapper um `dbt_utils.generate_surrogate_key()` |
| `psa_view()` | PSA-View mit `sys_islatest`-Flag |
| `reftable()` | Referenztabelle mit Checksummen-basierter Änderungserkennung |
| `effective_link()` | Join-Pattern: Link + DKLSAT mit Gültigkeitsfenster |
| `effective_sat()` | Join-Pattern: Satellite mit Gültigkeitsfenster |

---

## Backup-Ordner

Der Ordner `backup/` liegt **außerhalb** der dbt-Pfade (`models/`, `seeds/`) und wird daher von dbt nicht verarbeitet.

### `backup/removed_models/` und `backup/removed_seeds/`

Diese Ordner enthalten die aus dem aktiven Projekt entfernten Modelle und Seeds. Sie wurden entfernt, um die Tabellenanzahl pro Gruppe unter 40 zu halten. Die Dateien bleiben als Referenz erhalten:

- **Roadshow-Bereich**: Roadshow-Bestellungen, Vereinspartner, Kreditkarten
- **Lieferlogistik**: Lieferadressen, Lieferdienste, Lieferungen, Wohnorte
- **Erweiterte RDV-Modelle**: Zusätzliche Hubs, Links, Satellites und LSATs
- **BDV-Modelle**: Bridge-Tabellen (`brdg_orderitem_*`), berechneter Satellite (`csat_roadshowsale_kpi`)
- **Beispielmodelle**: `test_model`, `test_model_2`

### `backup/` (bestehend)

Enthält weitere Referenz-Implementierungen (Staging-Python-Modelle, alternative RDV-Modelle, OL-DM-Beispiele).

---

## Schnellstart

```bash
# Abhängigkeiten installieren
dbt deps

# Verbindung prüfen
dbt debug

# Seed-Daten laden (7 CSVs → Tabellen)
dbt seed

# Alle Modelle bauen (PSA-Views + RDV)
dbt run

# Tests ausführen
dbt test

# Alles zusammen
dbt build
```

---

## Übungsaufgaben (Hinweise für Studierende)

### Übung 3 – dbt Einarbeitung
- Eigenes Modell in einem Ordner `uebung3` erstellen
- Modell dokumentieren und dbt docs generieren

### Übung 4 – Tests und Macros
- Modell in Ordner `uebung4` erstellen
- Generic Tests hinzufügen
- Eigenes Makro für Währungsumrechnung erstellen

### Übung 5 – Star Schema
1. **Current-View-Makro** erstellen: Satellite → aktueller Stand (WHERE `sys_loadingid_validto = 999`)
2. **Current Views** für alle Satellites erzeugen
3. **Star Schema** modellieren und in `models/05_ol_dm/` implementieren (min. 1 Faktentabelle + 3 Dimensionstabellen)

### Tabellenbudget

| Kategorie | Anzahl |
|-----------|--------|
| Basis-Projekt (Seeds + Modelle) | 32 |
| Puffer für studentische Modelle | ~8 |
| **Maximum pro Gruppe** | **~40** |

> **Wichtig:** Bitte keine unnötigen Tabellen erzeugen. Nutzt `materialized: view` wo möglich.
> Temporäre Testmodelle nach Gebrauch wieder entfernen.

---

## Namenskonventionen

| Präfix | Bedeutung | Beispiel |
|--------|-----------|---------|
| `hub_` | Hub (Geschäftsobjekt) | `hub_customer` |
| `lnk_` | Link (Beziehung) | `lnk_webshoporder_customer` |
| `sat_` | Satellite (Kontextdaten) | `sat_customer_context` |
| `lsat_` | Link-Satellite (DK-LSAT) | `lsat_webshoporder_customer_dkh` |
| `ref_` | Referenztabelle | `ref_producttype` |
| `brdg_` | Bridge-Tabelle (BDV) | – (Backup) |
| `csat_` | Berechneter Satellite (BDV) | – (Backup) |
| `dim_` | Dimension (Data Mart) | von Studierenden zu erstellen |
| `fact_` | Faktentabelle (Data Mart) | von Studierenden zu erstellen |
| `v_` | PSA-View | `v_webshop_kunde` |

---

## Datenmodell (Kern)

```
                    ┌─────────────────────┐
                    │   hub_customer      │
                    │   (customer_id)     │
                    └────────┬────────────┘
                             │
              lnk_webshoporder_customer
                             │
                    ┌────────┴────────────┐
                    │  hub_webshoporder   │
                    │  (webshoporder_id)  │
                    └────────┬────────────┘
                             │
           lnk_webshoporderitem_webshoporder
                             │
                    ┌────────┴────────────┐
                    │ hub_webshoporderitem│
                    │ (orderitem_id,      │
                    │  webshoporder_id)   │
                    └────────┬────────────┘
                             │
            lnk_webshoporderitem_product
                             │
                    ┌────────┴────────────┐
                    │    hub_product      │
                    │    (product_id)     │
                    └────────┬────────────┘
                             │
             lnk_product_productcategory
                             │
                    ┌────────┴────────────┐
                    │ hub_productcategory │
                    │ (productcategory_id)│
                    └────────────────────┘
```

Jeder Hub hat einen zugehörigen Context-Satellite (`sat_*_context`).
Jeder Link hat einen Driving-Key LSAT (`lsat_*_dkh`).
