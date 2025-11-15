"use client"

import Link from "next/link"

export default function AboutPage() {
  return (
    <div className="min-h-screen p-8">
      <div className="max-w-2xl mx-auto space-y-8">
        <div className="space-y-4">
          <h1 className="text-4xl font-bold">About This App</h1>
          <p className="text-lg text-muted-foreground">
            This app was built with Dream App - the fastest way to ship
            production-ready applications.
          </p>
        </div>

        <div className="space-y-4">
          <h2 className="text-2xl font-semibold">What is Dream App?</h2>
          <p className="text-muted-foreground">
            Dream App helps you build real applications by talking to an AI
            assistant. No need to learn complex frameworks or spend hours
            configuring tools - just describe what you want and watch it come to
            life.
          </p>
        </div>

        <div className="space-y-4">
          <h2 className="text-2xl font-semibold">Features</h2>
          <ul className="space-y-2 text-muted-foreground">
            <li className="flex items-start gap-2">
              <span className="text-primary">✓</span>
              <span>Next.js 16 for modern web development</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-primary">✓</span>
              <span>Supabase for database and authentication</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-primary">✓</span>
              <span>Tailwind CSS for beautiful styling</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-primary">✓</span>
              <span>Vercel for instant deployments</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-primary">✓</span>
              <span>AI-powered development with Cursor</span>
            </li>
          </ul>
        </div>

        <div className="pt-8">
          <Link
            href="/"
            className="text-primary hover:underline font-medium"
          >
            ← Back to Home
          </Link>
        </div>
      </div>
    </div>
  )
}

