# HitTrax Progress Tracker

Single-file web app (`index.html`) for tracking a hitter's development session over session
from HitTrax data. No install, no server needed — open the file, or run the local preview.

## Two ways to log a session
1. **Paste batted balls** — copy the pitch-by-pitch rows out of HitTrax (CSV, a copied table,
   or one ball per line). Columns are auto-detected: Velo / Exit Velocity, LA / Launch Angle,
   Dist / Distance, Spray / Horiz Angle, Result / Play. Every summary metric is computed,
   plus the LA-vs-EV scatter and the spray chart.
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

## Data
Stored in the browser's localStorage on the device you use. Export a backup before switching
devices or clearing history.

## Local preview
```
python -m http.server 8776 --directory "C:/Users/user/Documents/HitTrax"
```
(also registered in .claude/launch.json as "hittrax")
