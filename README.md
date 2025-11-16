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
curl -fsSL https://getdreamapp.com/install | bash
```

## For Users

This is designed for complete beginners who want to build apps with AI. No coding experience required.

**What you get:**

- A fully configured development environment
- Cursor AI that can build features for you
- A deployed app on Vercel (already live!)
- Everything in one window - never leave Cursor

**Time to first app:** ~5 minutes

## For Developers

This repo contains:

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
- Fails at the very first real complexity
- Lock-in to the vendors

Manual Cursor setup requires:

- Installing 10+ tools manually
- Understanding git, SSH keys, databases
- Hours and days of configuration
- Years of technical knowledge and debugging.

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
2. Installer does it all
3. See Cursor open with their app
4. Ask Agent to build a feature
5. See it working in the Browser Tab
6. Have a live deployed app

**Target:** First feature built in < 30 minutes

## Roadmap

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
