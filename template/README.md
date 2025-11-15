# Dream App Template

This is your Dream App project - a production-ready Next.js application built to work seamlessly with AI assistance.

## Getting Started

1. **Open the project in Cursor**
2. **Press `Cmd + L`** to open your AI assistant
3. **Say "Get started"** to see your app and start building

That's it! Your AI assistant will help you build features, fix bugs, and deploy your app.

## What's Included

### Tech Stack
- **Next.js 16** - Modern React framework
- **TypeScript** - Type-safe code
- **Supabase** - Database + Authentication
- **Drizzle ORM** - Type-safe database queries
- **Tailwind CSS** - Utility-first styling
- **shadcn/ui** - Beautiful UI components

### Project Structure
```
├── app/                    # Next.js app directory
│   ├── (public)/          # Public pages (homepage, about)
│   ├── (auth)/            # Auth pages (login, signup)
│   ├── (app)/             # Protected app pages (dashboard)
│   └── api/               # API routes
├── components/ui/          # Reusable UI components
├── db/                    # Database schema
├── lib/                   # Utility functions
│   ├── api-client.ts      # Frontend API calls
│   ├── auth.ts            # Auth helpers
│   ├── db.ts              # Database connection
│   └── utils.ts           # General utilities
└── .cursorrules           # AI assistant rules

```

## Available Commands

```bash
pnpm dev          # Start development server
pnpm build        # Build for production
pnpm start        # Start production server
pnpm db:generate  # Generate database migrations
pnpm db:push      # Push schema to database
```

## Building Features

Just tell your AI assistant what you want! Examples:

- "Add a notes page where users can create and delete notes"
- "Create a profile page with user settings"
- "Add dark mode toggle"
- "Build a todo list with categories"

Your assistant will:
1. Create the necessary files
2. Write the code
3. Update the database if needed
4. Test it in the browser
5. Show you it working

## Architecture

### Client/Server Separation

This template uses a clean architecture:

**Components** (`"use client"`) → **API Client** → **API Routes** → **Database**

- All components are client components
- Components never touch the database directly
- All data flows through the API client
- API routes handle database operations

### Example: Adding a Feature

When you ask for a new feature, the AI will:

1. **Update database schema** (`db/schema.ts`)
2. **Create API route** (`app/api/...`)
3. **Add to API client** (`lib/api-client.ts`)
4. **Create component** (`app/...` or `components/...`)
5. **Test with browser** to verify it works

All of this happens automatically!

## Deployment

Your app is already deployed to Vercel!

To deploy updates:
- Just ask: "Deploy this to production"
- The AI will commit your changes and push to GitHub
- Vercel automatically deploys from GitHub

## Environment Variables

Your `.env.local` file contains:
- `NEXT_PUBLIC_SUPABASE_URL` - Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Supabase public key
- `DATABASE_URL` - Database connection string
- `NEXTAUTH_URL` - Your app URL
- `NEXTAUTH_SECRET` - Session secret

These are automatically configured during setup!

## Need Help?

Press `Cmd + L` and ask your AI assistant anything:
- "How does this work?"
- "What can I build?"
- "I'm stuck, can you help?"
- "Show me examples"

---

**Built with [Dream App](https://getdreamapp.com)** - Ship apps with AI ✨

