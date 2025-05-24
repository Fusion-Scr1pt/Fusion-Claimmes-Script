# Claimmes Script voor FiveM

Dit script biedt een systeem waarmee spelers een mes kunnen claimen in je FiveM server en het opnieuw kunnen resetten, via de commando's `/claimmes` en `/resetmes`. Het script logt acties naar Discord via webhooks en maakt gebruik van ESX voor de serverintegratie en OxMySQL voor de database interactie.

## Functies

1. **Claimmes (`/claimmes`)**
   - Spelers kunnen het mes claimen als ze het nog niet hebben gedaan.
   - Wanneer geclaimd, ontvangt de speler een item (`weapon_switchblade`) in zijn inventaris.
   - De database wordt bijgewerkt om de claimstatus van het mes bij te houden.
   - Een Discord-webhook logt de claimactie.

2. **Resetmes (`/resetmes`)**
   - Alleen admins kunnen de claimstatus van een speler resetten.
   - Reset de mes-claim status naar `FALSE` in de database.
   - Een Discord-webhook logt de resetactie.

## Installatie

### Vereisten

- **ESX**: Het script maakt gebruik van de ESX-framework voor spelersbeheer.
- **OxMySQL**: De database wordt beheerd via OxMySQL.
- **Ox_Lib**: Wordt gebruikt voor meldingen aan spelers via `ox_lib:notify`.
- **Discord Webhooks**: Webhooks voor het loggen van acties naar Discord.

### Stappen om het script te installeren

1. **Plaats de bestanden in je resource-map**:
   - Zorg ervoor dat de bestanden in een map binnen je `resources` directory worden geplaatst, bijvoorbeeld `fusion-claimmes`.

2. **Voeg het script toe aan je serverconfiguratie**:
   Voeg het volgende toe aan je `server.cfg`:
   ```bash
   ensure fusion-claimmes
