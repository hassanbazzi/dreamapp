# Dream App

**Ship production apps with AI in one command.**

A complete development environment setup that takes someone from a fresh Mac to building production apps with AI assistance in minutes.

Visit: [getdreamapp.com](https://getdreamapp.com)

## What This Does

One command installs:
- ✅ All development tools (Node, Git, Homebrew, etc.)
- ✅ Cursor AI editor
- ✅ Supabase (database + auth)
- ✅ Vercel (deployment)
- ✅ A production-ready Next.js app template
- ✅ Everything configured and deployed

Then opens Cursor with:
- ✅ Dev server auto-running
- ✅ Browser Tab ready to preview
- ✅ AI Agent configured for beginners
- ✅ Clear instructions to start building

## The One Command

```bash
curl -fsSL https://raw.githubusercontent.com/hassanbazzi/dreamapp/main/install.sh | bash
```

Or use the short URL (if you set up a redirect):

```bash
curl -fsSL https://getdreamapp.com/install | bash
```

## For Users

This is designed for complete beginners who want to build apps with AI. No coding experience required.

**What you get:**
- A fully configured development environment
- Cursor AI that can build features for you
- A deployed app on Vercel (already live!)
- Everything in one window - never leave Cursor

**Time to first app:** ~15 minutes

## For Developers

This repo contains:

## Repository Structure

Your `hassanbazzi/dreamapp` repo should look like this:

```
hassanbazzi/dreamapp/
├── install.sh              # The installer script (at root)
├── README.md              # This file
├── NEXT_STEPS.md          # Launch checklist
└── template/              # The Next.js template (in subfolder)
    ├── .cursorrules
    ├── package.json
    ├── app/
    ├── components/
    └── ... (all Next.js files)
```

The install script:
1. Clones your repo to a temp location
2. Copies the `template/` folder to the user's new project
3. Creates their own GitHub repo
4. Sets up everything else

### `/install.sh`
The main installation script that:
1. Installs system dependencies via Homebrew
2. Sets up GitHub authentication
3. Downloads and copies the template
4. Configures Supabase
5. Deploys to Vercel
6. Opens Cursor with everything ready

### `/template/`
The Next.js starter template with:
- Next.js 16 (App Router) + TypeScript
- Drizzle ORM + Supabase
- Supabase Auth (email/password)
- Tailwind CSS + shadcn/ui
- Cursor rules optimized for beginners
- Auto-starting dev server
- Comprehensive onboarding

## Development Setup

### Testing the Install Script

**On a fresh Mac (or VM):**
```bash
bash install.sh
```

**To test without installing:**
```bash
# Check syntax
bash -n install.sh

# Dry run (comment out actual installations)
# Edit script to add `echo` before brew/pnpm commands
```

### Setting Up the Repository

1. **Mark the repo as a template** on GitHub:
   - Go to `github.com/hassanbazzi/dreamapp/settings`
   - Check "Template repository"

2. **Push your code:**
   ```bash
   git add .
   git commit -m "Initial Dream App setup"
   git push origin main
   ```

3. **Test the installer:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/hassanbazzi/dreamapp/main/install.sh | bash
   ```

### Hosting the Install Script

**Option 1: GitHub Raw (Easiest!)**
The install script is automatically available via GitHub's raw content URL:
```bash
https://raw.githubusercontent.com/hassanbazzi/dreamapp/main/install.sh
```

No setup needed - just push to GitHub and it works!

**Option 2: Custom Short URL (Optional)**
If you own `getdreamapp.com`, set up a redirect:
- `getdreamapp.com/install` → `https://raw.githubusercontent.com/hassanbazzi/dreamapp/main/install.sh`

This gives you the nice URL: `curl -fsSL getdreamapp.com/install | bash`

## Architecture

### Tech Stack
- **Frontend/Backend:** Next.js 16 (App Router)
- **Database:** Supabase (Postgres via Drizzle ORM)
- **Auth:** Supabase Auth
- **Styling:** Tailwind CSS + shadcn/ui
- **Deployment:** Vercel
- **Development:** Cursor AI
- **Pattern:** Client components + API client pattern (clean separation)

### Key Files

**`.cursorrules`** - The secret sauce. Tells Cursor Agent:
- How to communicate with beginners
- What files to edit vs. avoid
- How to use @Browser to test features
- When to ask permission

**`.vscode/tasks.json`** - Auto-starts dev server and opens browser when Cursor opens

**`app/page.tsx`** - Beautiful welcome page with clear getting started instructions

## Why This Exists

Existing "no-code" AI platforms (Bolt, Lovable, V0) have issues:
- Infrastructure setup is flimsy
- Show too much overwhelming code
- Can't easily move to local development
- Not production-grade

Manual Cursor setup requires:
- Installing 10+ tools manually
- Understanding git, SSH keys, databases
- Hours of configuration
- Technical knowledge

**Dream App bridges the gap:**
- One command to install everything
- Production-grade infrastructure
- All in Cursor (never leave the window)
- AI Agent that can build AND test features
- Learning built-in
- Simple, magical experience

## Success Criteria

A complete beginner should:
1. Run one command
2. Answer a few prompts (Supabase keys, etc.)
3. See Cursor open with their app
4. Ask Agent to build a feature
5. See it working in the Browser Tab
6. Have a live deployed app

**Target:** First feature built in < 30 minutes

## Roadmap

**v1 (Weekend Launch):**
- [x] Installation script
- [ ] Template repository
- [ ] Landing page
- [ ] Demo video

**v2 (Future):**
- [ ] Windows support (WSL)
- [ ] Linux support
- [ ] Alternative stacks (Python/Django, etc.)
- [ ] More templates (SaaS, blog, e-commerce)
- [ ] Desktop app wrapper (Tauri)

## Contributing

This is currently a personal project but open to contributions!

Areas that need help:
- Testing on different Mac setups
- Improving error handling
- Adding more example features to template
- Documentation improvements

## License

MIT

## Credits

Built because my girlfriend shipped her first app in 2 days using Cursor, and I wanted to package that experience for everyone.

---

**Let's make shipping apps accessible to everyone.** 🎨✨

