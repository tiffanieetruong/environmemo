# EnvironMemo: classroom prototype

A mobile web app for COGS 123, Team 14. Classmates open one link on their phones, pick a username, then walk around the room scanning QR codes to unlock spots, read and add posts, earn badges and go on group walks. Everything syncs live between phones through Supabase.

## What's in this folder

| File | What it is |
| --- | --- |
| `index.html` | The whole app: screens, styles, fonts and logic in one file |
| `config.js` | Your Supabase keys (the only file you must edit) |
| `manifest.webmanifest`, `icon-192.png`, `icon-512.png` | Let people add the app to their home screen |
| `supabase/schema.sql` | Creates the database table (run once) |
| `supabase/seed.sql` | Loads the six spots and their starter stories |
| `supabase/reset-session.sql` | Wipes a session's activity but keeps the starter content |

## Setup (about 15 minutes)

### 1. Create the database
1. Make a free account at supabase.com and create a new project. Any name and region work; save the database password somewhere.
2. In the project, open **SQL Editor → New query**. Paste all of `supabase/schema.sql` and click **Run**.
3. Open another new query, paste all of `supabase/seed.sql`, and click **Run**.
4. Open **Project Settings → API Keys**. Copy the **Publishable key** (starts with `sb_publishable_`). Your **Project URL** (`https://….supabase.co`) is in the project's **Connect** dialog or **Project Settings → Data API**.

### 2. Add your keys
Open `config.js` and replace the two placeholder values:

```js
window.EM_CONFIG = {
  supabaseUrl: "https://abcdefgh.supabase.co",
  supabaseAnonKey: "sb_publishable_..."
};
```

The publishable key is meant to be public, so it's fine for it to sit in the site's code. Never paste the secret key here.

### 3. Put it online with Vercel
Pick either option:

- **Vercel Drop (no GitHub):** sign in at vercel.com, go to vercel.com/drop, drag this folder (or the zip) onto the page, name the project, and click **Deploy**. Each new drop creates a new project with a new link, so finish your edits before printing QR codes.
- **GitHub (best if you'll keep editing):** put this folder in a GitHub repo, then in Vercel choose **Add New → Project** and import it. Every change you push redeploys to the same link, so printed QR codes keep working.

Vercel gives you a link like `https://environmemo.vercel.app`. That's the link classmates open.

### 4. Make the QR codes
1. Open your link once with `?host` at the end, for example `https://environmemo.vercel.app/?host`. That phone or laptop becomes a host device.
2. Go to **Profile → QR codes for the room**. Host devices also see settings for the map's edge labels (Whiteboard, Door, and so on) and the number of spare QR codes.
3. Print the sheet, cut out the codes, and tape each one where its spot is on the map. Keep the spares for students to claim when they create new pins.

## Testing before the QR codes are printed
- **Test mode:** tap the QR icon at the top of the map. The Scan screen lists every spot; tap one to pretend you scanned it.
- **Typed codes:** the Scan screen also accepts the code printed under each QR (like `geisel`).
- **Several users on one phone:** **Profile → Switch account** lists the accounts used on that phone: tap one to sign back in, or create a new user. Use two phones, or a phone and a laptop, to try group walks.
- **Offline practice:** if `config.js` still has the placeholder keys, the app runs on its own with a yellow "Offline practice mode" banner and saves only to that device.

## Running a session
- Students open the link (or scan any QR code) and pick a username.
- On iPhone, Share → Add to Home Screen makes it open full screen like an app; on Android, use the browser menu's "Add to Home screen."
- The in-app scanner uses the phone camera on your Vercel site. Phones can also scan the codes with their normal camera app.
- Between sessions, run `supabase/reset-session.sql` in the SQL Editor to clear users and new posts while keeping the six starter spots.

## Vibecoding it further
Open this folder in Claude Code, Cursor or a similar tool and describe the change you want. A few pointers to give the AI:

- **Everything is in `index.html`.** The CSS is at the top; the screens are JavaScript functions named after them: `viewMap`, `viewChallenges`, `viewProfile`, `viewAdd`, `viewCreatePin`, `viewCollection`, `renderPin` (landmark page), `renderPage` (Create a New Post and the Scan screen), and `MODALS` (popups).
- **Colors** are CSS variables at the top of the file (`--bg`, `--ink`, `--accent`, the `--t-…` category colors and so on), copied from your Figma file.
- **Stories:** story tags are `TAGS`, story prompts are `PROMPTS`, and challenges and badges are the `CHALLENGES` list. A story record has `headline`, `text` (its first sentence is the sneak peek), `tags`, `photos` (up to 4), and `teaser` (`text` or `photo`: what people see before unlocking).
- **Data:** every record is one row in the `docs` table: `coll` (pins, posts, players, likes, checks, replies, invites, groups, scans or config), `id`, and `data` (the record as JSON). The `Store` object reads and writes it; you can browse it in Supabase under **Table Editor → docs**.
- **Fonts** (FOT-Seurat Pro B and KiwiSoda) are embedded in the file, trimmed to English characters. Seurat is a paid font, so check your license covers use on a website.

## Good to know
- **Security:** the database lets anyone with the link read and write. That's fine for a classroom test, but tighten the rules in `schema.sql` before sharing the link publicly.
- **Photos** (up to 4 per story) are shrunk on the phone and stored inside the story, so there's nothing extra to set up in Supabase.
