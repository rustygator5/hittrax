# HitTrax Progress Tracker

Single-file web app (`index.html`) for tracking a hitter's development session over session
from HitTrax data. No install, no server needed — open the file, or run the local preview.

## Two ways to log a session
1. **Upload the HitTrax CSV** (or drag it onto the drop zone) — .csv, .tsv or .txt. Title/player
   rows above the real header are skipped, quoted fields and tab/comma/semicolon delimiters are
   handled, and rows without a usable exit velo are reported and skipped. Pasting the rows into
   the box works exactly the same way, including headerless "78.4 14 205" lines.
   Columns are auto-detected: Velo / Exit Velocity, LA / Launch Angle, Dist / Distance,
   Spray / Horiz Angle, Result / Play, Pitch Velo, Date. Every summary metric is computed,
   plus the LA-vs-EV scatter and the spray chart.
   If the file covers several dates it offers to save one session per date (previewed in a table
   before saving); pitch speed is averaged from the file when you leave that field blank.
2. **Type the summary** — key in whatever the HitTrax session report screen shows.

## What it tracks
Max EV, Avg EV, Top-25% Avg EV, hard-hit average, barrel %, avg launch angle, sweet-spot LA %,
LD / FB / GB / PU mix, max & avg distance, BA, SLG, balls in play.

Definitions: GB <10 deg, LD 10-25, FB 25-50, PU >50. Sweet spot = 8-32 deg.
Hard hit = at or above the threshold on the Player & Data tab (defaults to the age group's
"good" floor). Barrel = hard hit AND 8-32 deg.

## Views
- **Dashboard** — latest session with deltas vs the previous one, PB badges, age benchmark bar, "what's moving"
- **Trends** — any metric over time with a 3-session rolling average; first / latest / total change
- **Sessions** — full history, tap for the breakdown (scatter, spray chart, every batted ball)
- **Report** — printable progress report (print to PDF or copy as text) for coaches
- **Player & Data** — player info, hard-hit threshold, JSON backup, CSV export, import

## Data & sync
Every session is saved to the browser's localStorage first, so the app works with no signal at
the cage. Sign in (Player & Data -> Sync across devices, or the pill in the header) with the same
account as the Budget app and it also syncs through Supabase, so the phone and the laptop share
one history.

Merge rules: sessions are unioned by id, the newest edit of a session wins, and deletes leave a
tombstone so a removed session doesn't come back from another device. Nothing is last-write-wins
except the player profile, which follows whichever device was touched most recently.

If a browser is already signed in to the Budget app or the hub on this domain, HitTrax borrows
that session automatically - no second login.

**One-time setup:** run `supabase-setup.sql` in the Supabase SQL editor to create the `hittrax`
table. Until then the header pill reads "Setup needed" and everything stays local (nothing is lost -
it uploads on the first successful sync).

Export a JSON backup before clearing browser history on a device that has never synced.

## Local preview
```
python -m http.server 8776 --directory "C:/Users/user/Documents/HitTrax"
```
(also registered in .claude/launch.json as "hittrax")
