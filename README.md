# HR Database & Analytics — PostgreSQL

**Portfolio project: Ksenia Samokhina**  
[Русская инструкция](README_RU.md)

A relational HR database and SQL analytics exercises using **fictional data**.

## Files

- `HR_Database_Analytics.sql` — the **full consolidated script** (schema + sample data + exercises and analytics), based on the original 977-line source.
- `HRM_Samokhina_Ksenia.backup` — custom-format PostgreSQL database backup, previously restored and checked in pgAdmin.
- `Analytics_After_Restore.sql` — four read-only analytics queries designed for the restored database.
- `README_RU.md` — Russian instructions.

## Option 1: Build from scratch

1. Install PostgreSQL (project developed with PostgreSQL 18) and pgAdmin.
2. In pgAdmin, create a **new empty database** (e.g. `HR_Portfolio_Fresh`).
3. Open **Query Tool** for that database and load `HR_Database_Analytics.sql`.
4. Execute the file **once**. It creates schema `staff2`, tables, sample data, views, functions, and runs SQL exercises.
5. Explore the tables under **Schemas → staff2 → Tables**.

**Do not execute the full script on an existing/restored database:** it contains CREATE/INSERT/UPDATE statements and is not designed to be rerun. The consolidated script has undergone static review, **not a verified end-to-end execution on a live PostgreSQL server in this environment**.

## Option 2: Restore the database

1. Create another new empty database in pgAdmin (e.g. `HR_Portfolio_Restored`).
2. Right-click the database → **Restore** → select `HRM_Samokhina_Ksenia.backup` (Format: Custom) → **Restore**.
3. Inspect `staff2` and its 9 populated tables (76 rows at the time of the prior check).
4. Open `Analytics_After_Restore.sql` in Query Tool and run the read-only queries.

The backup was previously restored successfully into a separate test database; the four read-only analytics queries were previously tested in pgAdmin. **The new consolidated SQL file has not yet been fully executed against a fresh PostgreSQL instance.**

## Data note

All employee names and records in this educational dataset are fictional. Do not use real personal data in public repositories.
